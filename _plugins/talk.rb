# _plugins/bibtex_tag.rb
module Jekyll
  class TalkTag < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
      @thumbnail_url, @pdf_url = markup.split(" ").map(&:strip)
    end

    # Generate a unique ID for this entry
    unique_id = "bibtex-" + Random.hex(4)

    def render(context)
      text = super
      site = context.registers[:site]
      converter = site.find_converter_instance(Jekyll::Converters::Markdown)

      # Set thumbnail string, distinguishing between videos and images
      if @thumbnail_url.end_with?(".mp4")
        thumbnail_string = "<video src=\"#{@thumbnail_url}\" alt=\"Talk thumbnail\"></video>"
      else
        thumbnail_string = "<img src=\"#{@thumbnail_url}\" alt=\"Talk thumbnail\">"
      end

      # Set PDF string, if one is provided
      pdf_string = ""
      if @pdf_url && @pdf_url != ""
        pdf_string = "<a href=\"#{@pdf_url}\" class=\"btn btn--bibtex btn--inverse\">PDF</a>"
      end

      # Wrap the BibTeX code in triple backticks and specify the language
      bibtex_code = "```bibtex\n#{text.strip}\n```"

      # Convert the BibTeX block using the Markdown converter
      processed_bibtex = converter.convert(bibtex_code)

      # Generate a unique ID for this entry
      unique_id = "bibtex-" + Random.hex(4)

      # Create the HTML structure
      html = <<~HTML
        <div class="bibtex-entry">
          <div class="bibtex-thumbnail">
            #{thumbnail_string}
          </div>
          <div class="bibtex-contents">
            <div class="talk-title"></div>
            <div class="talk-event"></div>
            <div class="talk-type"></div>
            <div class="talk-address"></div>
            <div class="bibtex-buttons">
              <a href="#" class="btn btn--bibtex btn--slides">Google Slides</a>
              #{pdf_string}
              <button class="btn btn--bibtex btn--bib" data-target="##{unique_id}">BibTeX</button>
            </div>
            <div id="#{unique_id}" class="bibtex-raw" style="display: none;">
              #{processed_bibtex}
            </div>
            <div class="bibtex-data">
              #{text}
            </div>
          </div>
        </div>
      HTML

      html
    end
  end
end

Liquid::Template.register_tag('talk', Jekyll::TalkTag)
