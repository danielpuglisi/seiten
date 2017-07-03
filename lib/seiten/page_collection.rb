module Seiten
  class PageCollection
    attr_accessor :navigation_id, :pages

    def initialize(options={})
      @navigation_id = options[:navigation_id]
      @pages         = options[:pages] || []
    end

    def navigation
      Seiten::Navigation.find_by(id: self.navigation_id)
    end

    def build(options={})
      Seiten::PageCollectionBuilder.call(self, options)
    end

    def all
      self.pages.to_a
    end

    def find(id)
      self.pages.select { |page| page.id == id }.first
    end

    def find_by(params)
      where(params).first
    end

    def where(params)
      self.pages.select do |page|
        params.all? do |param|
          page.send(param[0]) == param[1]
        end
      end
    end

    def new(params={})
      page = Seiten::Page.new(params.merge(navigation_id: navigation_id))
      self.pages << page
      page
    end
  end
end
