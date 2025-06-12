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
      content = preprocess_fragmented_equations(content)
      content = preprocess_titles(content)
      content = preprocess_lists(content)
      content
    end

    def preprocess_fragmented_equations(content)
      content.gsub(/\$\$>>\s*(.*?)\s*\$\$/m) do
        block = Regexp.last_match(1)

        lines = block.lines.map(&:chomp)
        result = []

        inside_equation = false

        lines.each do |line|
          if line.strip.start_with?('\\begin{') || line.strip.start_with?('\\end{')
            result << line
            next
          end

          # Only transform lines inside the equation
          if !line.strip.empty?
            transformed_line = line.dup

            # Replace "\\" with "\cr"
            transformed_line.gsub!(/\\\\/, '\cr')

            # Replace "&" with "&{} "
            transformed_line.gsub!(/&/, '&{} ')

            # Extract RHS of &= or similar, preserve math spacing and wrap with class
            if transformed_line =~ /(.*?&\{\}\s*)(.*?)(\\cr)?\s*$/
              prefix = $1
              expr = $2
              suffix = $3 || ""
              wrapped = "#{prefix}\\class{fragment}{#{expr.strip}}#{suffix}"
              result << wrapped
            else
              # In case the line doesn't match, still wrap the whole line as a fallback
              result << "\\class{fragment}{#{transformed_line.strip}}"
            end
          else
            result << line
          end
        end

        "$$\n" + result.join("\n") + "\n$$"
      end
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
