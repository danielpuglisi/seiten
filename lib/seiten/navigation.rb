module Seiten
  class Navigation
    attr_accessor :name, :locale, :config, :dir, :page_collection

    def initialize(options={})
      @name   ||= options[:name]
      @locale ||= options[:locale]
      @config ||= options[:config] || File.join(Rails.root, Seiten.config[:config_dir], "#{id}.yml")
      @dir    ||= options[:dir]    || File.join(Rails.root, Seiten.config[:pages_dir], @name.to_s, @locale.to_s)
      @page_collection = Seiten::PageCollection.new(navigation_id: id)
    end

    class << self
      def find_by(params={})
        where(params).first
      end

      def where(params={})
        Seiten.navigations.select do |navigation|
          params.all? do |param|
            navigation.send(param[0]) == param[1]
          end
        end
      end
    end

    def id
      "%s.%s" % [name, locale]
    end

    def pages
      page_collection
    end

    def pages=(pages_array)
      page_collection.pages = pages_array.map { |page| page.navigation_id = id; page }
      page_collection
    end

    # TODO: Move to Seiten::PageCollection#build
    def build_page_collection(options={})
      raw_pages  = options[:raw_pages] || YAML.load_file(config)
      parent_id  = options[:parent_id] # || nil
      layout     = options[:layout]
      prefix_url = options[:prefix_url] || ""

      @id ||= 1
      @parsed_pages ||= []

      raw_pages.each_index do |i|

        # Load page and set parent_id and generated page id
        page = raw_pages[i]
        page["id"] = @id
        page["parent_id"] = parent_id
        page["layout"] ||= layout

        # Increment generated id
        @id += 1

        # Build slug
        page["slug"] = Seiten::SlugBuilder.call(page, prefix_url)

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
          if page["redirect"].is_a?(TrueClass)
            page["redirect"] = Seiten::SlugBuilder.call(page["nodes"].first, page["slug"])
          else
            page["redirect"] = page["redirect"][1..-1] if page["redirect"][0] == "/"
          end
        end

        # Load children
        if page["nodes"]
          build_page_collection(raw_pages: page["nodes"], parent_id: page["id"], prefix_url: page["slug"], layout: inherited_layout, external: page["external"])
        end

        page_params = page.each_with_object({}){|(k,v), h| h[k.to_sym] = v}
        @parsed_pages << Seiten::Page.new(page_params)
      end

      self.pages = @parsed_pages
    end
  end
end
