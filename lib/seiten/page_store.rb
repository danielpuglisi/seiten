module Seiten

  class PageStore

    attr_accessor :storage_type, :storage_file, :storage_directory

    def initialize(options={})
      @storage_type      = options[:storage_type]
      @storage_file      = options[:storage_file]

      @storage_type ||= Seiten.config[:storage_type]
      @storage_file ||= File.join(Rails.root, Seiten.config[:storage_file])
    end

    def build_link(page, prefix_url)
      slug = page["url"].nil? ? page["title"].parameterize : page["url"]
      unless slug[0] == "/" || !!(slug.match(/^https?:\/\/.+/))
        slug = "#{prefix_url}/#{slug}"
      end
      slug
    end

    def load_pages(options={})

      pages      = options[:pages]
      parent_id  = options[:parent_id] # || nil
      layout     = options[:layout]
      prefix_url = options[:prefix_url] || ""

      # Setting default values
      if storage_type == :yaml
        pages ||= YAML.load_file(storage_file)
      end

      @id         ||= 1
      @navigation ||= []

      pages.each_index do |i|

        # Load page and set parent_id and generated page id
        page = pages[i]
        page["id"] = @id
        page["parent_id"] = parent_id
        page["layout"] ||= layout

        # Increment generated id
        @id += 1

        # Build link
        page["slug"] = build_link(page, prefix_url)

        # Set layout
        if page["layout"]
          if page["layout"].is_a?(String)
            inherited_layout = page["layout"]
          elsif page["layout"].is_a?(Hash)
            if page["layout"]["inherit"]
              inherited_layout = page["layout"]
            else
              inherited_layout = nil
            end
            page["layout"] = page["layout"]["name"]
          end
        end

        # Set redirect
        if page["redirect"]
          # page["redirect"].is_a?(Boolean) ? page["redirect"] = page["nodes"] : page["redirect"]
        end

        # Load children
        if page["nodes"]
          load_pages(pages: page["nodes"], parent_id: page["id"], prefix_url: page["slug"], layout: inherited_layout)
        end

        page_params = page.each_with_object({}){|(k,v), h| h[k.to_sym] = v}
        @navigation << Page.new(page_params)
      end

      @navigation
    end
  end
end
