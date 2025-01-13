# _plugins/bibtex_tag.rb
module Jekyll
  class BibtexTag < Liquid::Block
    def initialize(tag_name, image_url, tokens)
      super
      @image_url = image_url.strip
    end

    # Generate a unique ID for this entry
    unique_id = "bibtex-" + Random.hex(4)

    def render(context)
      text = super
      site = context.registers[:site]
      converter = site.find_converter_instance(Jekyll::Converters::Markdown)

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
            <img src="#{@image_url}" alt="Paper thumbnail">
          </div>
          <div class="bibtex-contents">
            <div class="paper-title"></div>
            <div class="paper-authors"></div>
            <div class="paper-journal"></div>
            <div class="bibtex-buttons">
              <a href="#" class="btn btn--bibtex btn--journal">Journal</a>
              <a href="#" class="btn btn--bibtex btn--arxiv">arXiv</a>
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

Liquid::Template.register_tag('bibtex', Jekyll::BibtexTag)
