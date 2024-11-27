module Jekyll
  class RandomQuote < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      plugin_dir = File.dirname(__FILE__)
      quotes = fetch_quote(plugin_dir)
      quote = quotes['results'][0]
      "#{quote['content']} - #{quote['author']}"
      
    end

    private

    def fetch_quote(plugin_dir)
      file_path = File.join(plugin_dir, 'quote.json')
      JSON.parse(File.read(file_path))
    end
  end
end

Liquid::Template.register_tag('random_quote', Jekyll::RandomQuote)