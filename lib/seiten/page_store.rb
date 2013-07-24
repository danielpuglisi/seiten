module Seiten

  class PageStore

    attr_accessor :storage_type, :storage_file, :storage_directory

    def initialize(options={})
      @storage_type      = options[:storage_type]
      @storage_file      = options[:storage_file]

      @storage_type ||= Seiten.config[:storage_type]
      @storage_file ||= File.join(Rails.root, Seiten.config[:storage_file])
    end

    def load_pages(options={})

      pages  = options[:pages]
      parent_id = options[:parent_id]
      url       = options[:url]

      # Setting default values
      if storage_type == :yaml
        pages ||= YAML.load_file(storage_file)
      end
      parent_id   ||= nil
      url         ||= ""
      @id         ||= 1
      @navigation ||= []

      pages.each_index do |i|

        page = pages[i]
        page["id"] = @id
        page["parent_id"] = parent_id
        @id += 1

        # Build link
        slug = page["url"].nil? ? page["title"].parameterize : page["url"]
        if slug[0] == "/" || !!(slug.match(/^https?:\/\/.+/))
          page["slug"] = slug
        else
          page["slug"] = "#{url}/#{slug}"
        end

        if page["nodes"]
          load_pages(pages: page["nodes"], parent_id: page["id"], url: page["slug"])
        end

        page.delete("nodes")
        page_params = page.each_with_object({}){|(k,v), h| h[k.to_sym] = v}
        @navigation << Page.new(page_params)
      end

      @navigation
    end
  end
end
