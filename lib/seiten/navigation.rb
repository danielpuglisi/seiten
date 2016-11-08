module Seiten

  class Navigation

    attr_accessor :name, :locale, :config, :dir, :pages

    def initialize(options={})
      @name   ||= options[:name]
      @locale ||= options[:locale]
      @config ||= options[:config] || File.join(Rails.root, Seiten.config[:config_dir], "#{id}.yml")
      @dir    ||= options[:dir]    || File.join(Rails.root, Seiten.config[:pages_dir], @name.to_s, @locale.to_s)
      @pages  ||= load_pages
    end

    class << self
      # def current
      #   Seiten.config[:current_page_store]
      # end

      # def set_current_page_store(options={})
      #   Seiten.config[:current_page_store] = find_by(options) if options
      # end

      # def find_by(options={})
      #   tmp_storages = storages
      #   options.each do |option|
      #     tmp_storages = tmp_storages.select { |storage| storage.send(option[0]) == option[1] }
      #   end
      #   tmp_storages.first
      # end
    end

    def id
      "%s.%s" % [name, locale]
    end

    # TODO: Move to Seiten::LinkBuilder
    def build_link(page, prefix_url="")

      # if url is nil parameterize title otherwise just use url
      slug = page["url"].nil? ? page["title"].parameterize : page["url"]

      # prepend prefix_url if slug is not root or external url
      unless slug[0] == "/" || !!(slug.match(/^https?:\/\/.+/)) || !prefix_url.present?
        slug = "#{prefix_url}/#{slug}"
      end

      # return empty string if page slug is /
      if slug == "/" || page["root"] == true
        slug = ""
      end

      # remove leading slash if present
      if slug
        slug = slug[1..-1] if slug[0] == "/"
      end

      slug
    end

    # TODO: Move to Seiten::NavigationBuilder
    def load_pages(options={})

      pages      = options[:pages]
      parent_id  = options[:parent_id] # || nil
      layout     = options[:layout]
      prefix_url = options[:prefix_url] || ""

      pages ||= YAML.load_file(config)

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
          if page["redirect"].is_a?(TrueClass)
            page["redirect"] = build_link(page["nodes"].first, page["slug"])
          else
            page["redirect"] = page["redirect"][1..-1] if page["redirect"][0] == "/"
          end
        end

        # Load children
        if page["nodes"]
          load_pages(pages: page["nodes"], parent_id: page["id"], prefix_url: page["slug"], layout: inherited_layout, external: page["external"])
        end

        page_params = page.each_with_object({}){|(k,v), h| h[k.to_sym] = v}
        @navigation << Page.new(page_params)
      end

      @navigation
    end
  end
end
