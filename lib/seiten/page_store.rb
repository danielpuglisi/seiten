module Seiten

  class PageStore

    attr_accessor :storage_type, :storage_file, :storage_language, :storage_directory, :pages

    def initialize(options={})
      @storage_type      = options[:storage_type] || Seiten.config[:default_storage_type]
      @storage_directory = options[:storage_directory] || File.join(Rails.root, Seiten.config[:default_storage_directory])
      @storage_language  = options[:storage_language] || I18n.locale
      @storage_language  = @storage_language.to_sym
      @storage_file      = options[:storage_file] || load_storage_file
      @pages             = load_pages
    end

    @storages = []

    class << self

      def storages
        @storages
      end

      def storages=(storages)
        @storages = storages
      end

      def current
        Seiten.config[:current_page_store]
      end

      def set_current_page_store(options={})
        Seiten.config[:current_page_store] = find_by(options) if options
      end

      def find_by(options={})
        tmp_storages = storages
        options.each do |option|
          tmp_storages = tmp_storages.select { |storage| storage.send(option[0]) == option[1] }
        end
        tmp_storages.first
      end

      def initialize_page_stores
        # Check if config/navigation exists?
        # If true:  Initialize localized navigation page stores with locale language and directory
        # If false: Initialize the default storage file
        if File.directory?(File.join(Rails.root, Seiten.config[:default_storage_file]))
          Dir[File.join(Rails.root, Seiten.config[:default_storage_file], "*.yml")].each do |file|
            locale = File.basename(file, '.yml')
            Seiten::PageStore.storages << Seiten::PageStore.new(storage_language: locale, storage_directory: File.join(Rails.root, "app", "pages", locale))
          end
        else
          Seiten::PageStore.storages << Seiten::PageStore.new(storage_language: I18n.default_locale)
        end
        set_current_page_store(storage_language: I18n.default_locale)
      end

    end

    def load_storage_file
      if File.exists?(File.join(Rails.root, Seiten.config[:default_storage_file], "#{storage_language}.yml"))
        File.join(Rails.root, Seiten.config[:default_storage_file], "#{storage_language}.yml")
      else
        File.join(Rails.root, "#{Seiten.config[:default_storage_file]}.yml")
      end
    end

    def file_path(options={})
      File.join(storage_directory, options[:filename])
    end

    def build_link(page, prefix_url="")

      # if url is nil parameterize title otherwise just use url
      slug = page["url"].nil? ? page["title"].parameterize : page["url"]

      # prepend prefix_url if slug is not root or external url
      unless slug[0] == "/" || !!(slug.match(/^https?:\/\/.+/)) || !prefix_url.present?
        slug = "#{prefix_url}/#{slug}"
      end

      # return nil if page slug is /
      if slug == "/" || page["root"] == true
        slug = nil
      end

      # remove leading slash if present
      if slug
        slug = slug[1..-1] if slug[0] == "/"
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
