module Seiten
  class PageCollectionBuilder
    def self.call(page_collection, options={})
      pages      = options[:pages]
      parent_id  = options[:parent_id] # || nil
      layout     = options[:layout]
      prefix_url = options[:prefix_url] || ""

      @id ||= 1
      @parsed_pages ||= []

      pages.each_index do |i|

        # Load page and set parent_id and generated page id
        page = pages[i]
        page["id"] = @id
        page["parent_id"] = parent_id
        page["layout"] ||= layout

        # Increment generated id
        @id += 1

        # Build slug
        raise PageError, "The `url` option can not be an external path. Use the `refer` option to link to external resources." if page["url"] && !!(page["url"].match(/^https?:\/\/.+/))
        slug = Seiten::SlugBuilder.call(page, prefix_url) unless page['url'].is_a?(FalseClass)

        # Set refer
        if page["refer"]
          if page["refer"].is_a?(TrueClass)
            page["refer"] = "/" + Seiten::SlugBuilder.call(page["nodes"].first, page["slug"])
          end
          raise PageError, "The `refer` option must be `true` or an absolute or external path" if page["refer"] != true && page["refer"][0] != "/" && !(page["refer"].match(/^https?:\/\/.+/))
        else
          page["slug"] = slug
        end

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

        # Load children
        if page["nodes"]
          self.call(page_collection, pages: page["nodes"], parent_id: page["id"], prefix_url: slug, layout: inherited_layout, external: page["external"])
        end

        page_params = page.each_with_object({}){|(k,v), h| h[k.to_sym] = v}
        @parsed_pages << page_collection.new(page_params)
      end

      @parsed_pages
    end
  end

  class PageError < StandardError
  end
end
