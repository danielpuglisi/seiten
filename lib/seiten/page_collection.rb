module Seiten
  class PageCollection
    attr_accessor :navigation_id, :pages

    def initialize(options = {})
      @navigation_id = options[:navigation_id]
      @pages         = options[:pages] || []
    end

    def navigation
      Seiten::Navigation.find_by(id: navigation_id)
    end

    def build(options = {})
      Seiten::PageCollectionBuilder.call(self, options)
    end

    def all
      pages.to_a
    end

    def find(id)
      find_by(id: id)
    end

    def find_by(params)
      @find_by ||= {}
      return @find_by[params] if @find_by.key?(params)

      @find_by[params] = pages.find do |page|
        params.all? do |k, v|
          page.send(k) == v
        end
      end
    end

    def where(params)
      @where ||= {}
      return @where[params] if @where.key?(params)

      @where[params] = pages.select do |page|
        params.all? do |k, v|
          page.send(k) == v
        end
      end
    end

    def new(params = {})
      page = Seiten::Page.new(params.merge(navigation_id: navigation_id))
      pages << page
      page
    end
  end
end
