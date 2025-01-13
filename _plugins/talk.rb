# _plugins/bibtex_tag.rb
module Jekyll
  class TalkTag < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
      @thumbnail_url, @pdf_url, @thumbnail_caption, @caption_url = markup.split(" ").map(&:strip)
    end

    # Generate a unique ID for this entry
    unique_id = "bibtex-" + Random.hex(4)

    def render(context)
      text = super
      site = context.registers[:site]
      converter = site.find_converter_instance(Jekyll::Converters::Markdown)

      # Set thumbnail string, distinguishing between videos and images
      if @thumbnail_url.end_with?(".mp4")
        thumbnail_string = "<video src=\"/assets/videos/#{@thumbnail_url}\" alt=\"Talk thumbnail\"></video>"
      else
        thumbnail_string = "<img src=\"/assets/images/talks/#{@thumbnail_url}\" alt=\"Talk thumbnail\">"
      end

      # Set PDF string, if one is provided
      pdf_string = ""
      if @pdf_url && @pdf_url != ""
        pdf_string = "<a href=\"/assets/docs/talks/#{@pdf_url}\" class=\"btn btn--bibtex btn--inverse\">PDF</a>"
      end

      # Set thumbnail caption, if one is provided
      thumbnail_caption = ""
      if @thumbnail_caption && @thumbnail_caption != ""
        if @caption_url && @caption_url != ""
          thumbnail_caption = "<div class=\"caption\"><a href=\"#{@caption_url}\">Credit: #{@thumbnail_caption}</a></div>"
        else
          thumbnail_caption = "<div class=\"caption\">Credit: #{@thumbnail_caption}</div>"
        end
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
            #{thumbnail_caption}
          </div>
          <div class="bibtex-contents">
            <div class="talk-title"></div>
            <div class="talk-event"></div>
            <div class="talk-type"></div>
            <div class="talk-address"></div>
            <div class="bibtex-buttons">
              <a href="#" class="btn btn--bibtex btn--slides">Google Slides</a>
              <a href="#" class="btn btn--bibtex btn--github">Github</a>
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
