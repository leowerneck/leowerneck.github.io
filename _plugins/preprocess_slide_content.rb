module Jekyll
  class PreprocessedSlides < Generator
    def generate(site)
      site.pages.each do |page|
        next unless page.data["layout"] == "slides"

        original = page.content.dup
        page.data["preprocessed_slide_content"] = preprocess(original)

        Jekyll.logger.info "--- BEGIN ---"
        Jekyll.logger.info page.data["preprocessed_slide_content"] # This will print the multi-line string
        Jekyll.logger.info "--- END ---"
      end
    end

    private

    def preprocess(content)
      content = preprocess_equations(content)
      content = preprocess_titles(content)
      content = preprocess_lists(content)
      content
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
