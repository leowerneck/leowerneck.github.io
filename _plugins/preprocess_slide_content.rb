module Jekyll
  class PreprocessedSlides < Generator
    def generate(site)
      site.posts.docs.each { |post| post.data['preprocessed_slide_content'] = preprocess(post.content) }
      site.pages.each { |page| page.data['preprocessed_slide_content'] = preprocess(page.content) }
      site.collections.each do |_, collection|
        collection.docs.each { |doc| doc.data['preprocessed_slide_content'] = preprocess(doc.content) }
      end
    end

    private

    def preprocess(content)
      content = preprocess_title_slide(content)
      content = preprocess_equations(content)
      content = preprocess_lists(content)
      content = preprocess_titles(content)
      content
    end

    def preprocess_title_slide(content)
      lines = content.strip.split("\n")
      first_slide_lines = ["<!--begin title slide-->"]
      n = 0
      lines.each_with_index do |line, i|
        if line.strip == "<!--s-->"
          n = i
          break
        end
        first_slide_lines << line
      end
      first_slide_lines << "<!--end title slide-->"
      (first_slide_lines + lines[n..]).join("\n")
    end

    def preprocess_equations(content)
      content.gsub("$$>", '$$<!--.element class="fragment"-->')
    end

    def preprocess_lists(content)
      lines = content.strip.split("\n")
      html = []
      stack = []
      first_list = true

      lines.each do |line|
        if match = line.match(/(\s*)>\* (.*)/)
          indent, list_item = match.captures
          depth = indent.length / 4 + 1

          if first_list
            html << "<ul>"
            first_list = false
          end

          while stack.length > depth
            html << "</ul>"
            stack.pop
          end

          while stack.length < depth
            html << "<ul>"
            stack.push(depth)
          end

          html << "<li class=\"fragment\">#{list_item}</li>"
        else
          while stack.any?
            html << "</ul>"
            stack.pop
          end
          html << line
        end
      end

      while stack.any?
        html << "</ul>"
        stack.pop
      end

      html.join("\n")
    end

    def preprocess_titles(content)
      content.gsub(/^## (.+)$/) do
        "<div class=\"slide-title\">\n  <h2>#{$1}</h2>\n  <hr>\n</div>"
      end
    end
  end
end
