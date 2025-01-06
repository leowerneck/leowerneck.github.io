# _plugins/bibtex_tag.rb
module Jekyll
  class BibtexTag < Liquid::Block
    def initialize(tag_name, image_url, tokens)
      super
      @image_url = image_url.strip
    end

    def render(context)
      text = super
      site = context.registers[:site]
      converter = site.find_converter_instance(Jekyll::Converters::Markdown)

      # Create the HTML structure
      html = <<~HTML
        <div class="bibtex-entry">
          <div class="bibtex-image">
            <img src="#{@image_url}" alt="Paper thumbnail">
          </div>
          <div class="bibtex-contents">
            <div class="paper-title"></div>
            <div class="paper-authors"></div>
            <div class="paper-journal"></div>
            <div class="bibtex-buttons">
              <a href="#" class="btn btn--bibtex btn--journal">Journal</a>
              <a href="#" class="btn btn--bibtex btn--arxiv">arXiv</a>
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
