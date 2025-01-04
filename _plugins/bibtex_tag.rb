# _plugins/paper_tag.rb
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
          <div class="bibtex-details">
            <p></p>
          </div>
          <div class="bibtex-data">
            #{text}
          </div>
        </div>
      HTML

      html
    end
  end
end

Liquid::Template.register_tag('bibtex', Jekyll::BibtexTag)
