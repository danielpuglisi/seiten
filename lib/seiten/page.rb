# frozen_string_literal: true

module Seiten
  class Page
    attr_accessor :navigation_id, :id, :parent_id, :title, :slug, :refer, :key, :data, :html_options
    attr_writer :layout

    # initialize Page object with attributes
    def initialize(options={})
      @navigation_id  = options[:navigation_id]
      @id             = options[:id]
      @parent_id      = options[:parent_id]
      @title          = options[:title]
      @slug           = options[:slug]
      @refer          = options[:refer]
      @key            = options[:key]&.to_s
      @layout         = options[:layout]
      @data           = options[:data].each_with_object({}){|(k,v), h| h[k.to_sym] = v} if options[:data]
      @data         ||= {}
      @html_options   = options[:html].each_with_object({}){|(k,v), h| h[k.to_sym] = v} if options[:html]
      @html_options ||= {}
    end

    def navigation
      Seiten::Navigation.find_by(id: navigation_id)
    end

    # returns true if slug starts with http:// or https://
    def external?
      !!(slug.match(/^https?:\/\/.+/))
    end

    # get parent of page
    def parent
      navigation.pages.find(parent_id) if parent_id
    end

    def parent?
      parent.present?
    end

    def ancestors
      return @ancestors unless @ancestors.nil?

      @ancestors = []
      return @ancestors unless parent?

      ancestor = parent
      loop do
        @ancestors << ancestor
        ancestor = ancestor.parent
        break if ancestor.nil?
      end

      @ancestors
    end

    def self_and_ancestors
      @self_and_ancestors ||= ancestors.insert(0, self)
    end

    def breadcrumbs
      @breadcrumbs ||= self_and_ancestors.reverse
    end

    # get root page of current page branch
    def root
      if self.parent?
        self.parent.root
      else
        self
      end
    end

    # The page's place in its navigation tree: the index among its siblings, from the root down
    # (e.g. [2, 0] for the first child of the third top-level page).
    def position
      @position ||= (parent ? parent.position : []) + [navigation.pages.where(parent_id: parent_id).index(self)]
    end

    # The same page in the navigation of the same name in another locale: the page at the same
    # position, or, for a page with a `key`, the page with the same key. Nil when there is none.
    def translation(locale)
      locale = locale.to_s
      return self if locale == navigation.locale

      other = Seiten::Navigation.find_by(name: navigation.name, locale: locale)
      return unless other

      if key
        other.pages.find_by(key: key)
      else
        page = other.pages.all.find { |candidate| candidate.position == position }
        page unless page&.key
      end
    end

    # This page in every locale that has it, by locale (including its own).
    def translations
      Seiten::Navigation.where(name: navigation.name).each_with_object({}) do |other, translations|
        page = translation(other.locale)
        translations[other.locale] = page if page
      end
    end

    # get children of page
    def children
      navigation.pages.where(parent_id: id)
    end

    def children?
      children.any?
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

    def template_path
      [
        navigation_id.gsub(/\./, '/'),
        slug.present? ? slug : Seiten.config[:root_page]
      ].join('/')
    end
    alias_method :to_s, :template_path

    def path
      return refer if refer
      return '#' if slug.nil?
      return slug if external?

      navigation_name = navigation.name == 'application' ? nil : navigation.name

      [:seiten, navigation_name.try(:to_sym), :page, { slug: slug }]
    end

    def layout
      @layout || Seiten.config[:default_layout]
    end
  end
end
