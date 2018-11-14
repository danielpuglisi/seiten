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
      # return page_collection
      # NOTE: This doesn't work and just returns page_array.
      # I think because page_collection#pages= attr_accessor is called first
      # and thus why our return call is ignored.
    end
  end
end
