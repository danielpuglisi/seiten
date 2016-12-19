module Seiten
  class PageCollection
    attr_accessor :navigation_id, :pages

    def initialize(options={})
      @navigation_id = options[:navigation_id]
      @pages         = options[:pages] || []
    end

    def all
      pages.to_a
    end

    def find(id)
      pages.select { |page| page.id == id }.first
    end

    def find_by(params)
      where(params).first
    end

    def where(params)
      pages.select do |page|
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
