module Seiten

  class Page

    attr_accessor :id, :parent_id, :title, :children, :slug, :redirect, :layout

    # initialize Page object with attributes
    def initialize(options={})
      @id        = options[:id]
      @parent_id = options[:parent_id]
      @title     = options[:title]
      @slug      = options[:slug]
      @redirect  = options[:redirect]
      @layout    = options[:layout]
    end

    class << self

      def all
        Seiten::PageStore.current.pages
      end

      # find page by id
      def find(id)
        all.select { |page| page.id == id }.first
      end

      # find all pages by parent_id
      def find_by_parent_id(parent_id)
        all.select { |page| page.parent_id == parent_id }
      end

      # find a page by slug
      def find_by_slug(slug)
        if slug
          slug = slug[1..-1] if slug[0] == "/"
        end
        all.select { |page| page.slug == slug }.first
      end

      # get breadcrumb of given page (reversed)
      def get_breadcrumb(page)
        pages ||= []
        pages << page
        if page.parent
          pages << get_breadcrumb(page.parent)
        end
        pages.flatten
      end

    end

    # get parent of page
    def parent
      Page.find(parent_id)
    end

    # get children of page
    def children
      Page.all.select { |page| page.parent_id == id }
    end

    # true if child is children of page
    def parent_of?(child)
      page = self
      if child
        if page.id == child.parent_id
          true
        else
          child.parent.nil? ? false : page.parent_of?(child.parent)
        end
      end
    end

    # true if page is equal current_page or parent of current_page
    def active?(current_page)
      if current_page
        if id == current_page.id
          true
        elsif parent_of?(current_page)
          true
        else
          false
        end
      end
    end
  end
end
