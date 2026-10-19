require 'seiten/engine'
require 'seiten/railtie'
require 'seiten/navigation'
require 'seiten/page'
require 'seiten/page_collection'
require 'seiten/page_collection_builder'
require 'seiten/slug_builder'
require 'seiten/routes_helper'
require 'seiten/helpers/current'
require 'seiten/helpers/backend'
require 'seiten/helpers/frontend'
require 'seiten/html/helpers'
require 'seiten/html/navigation'
require 'seiten/html/breadcrumb'
require 'seiten/errors/base_error'
require 'seiten/errors/page_error'
require 'seiten/errors/routing_error'

module Seiten
  @config = {
    config_dir: File.join('config', 'navigations'),
    pages_dir:  File.join('app', 'pages'),
    root_page: 'home',
    i18n_scope: 'navigations',
    default_layout: 'application',
    html: {
      navigation: {
        base: 'navigation',
        item: 'navigation__item',
        nodes: 'navigation__nodes',
      },
      breadcrumb: {
        base: 'breadcrumb',
        item: 'breadcrumb__item',
        separator: 'breadcrumb__separator',
      },
      modifier: {
        base: nil, # if nil we use the main class combined with the element class
        separator: '--', # modifier separator
        parent: 'parent',
        active: 'active',
        current: 'current',
        expanded: 'expanded'
      }
    }
  }

  @navigations = []
  @i18n_files = {}
  @i18n_navigations = nil
  @i18n_lock = Mutex.new

  class << self
    def config
      @config
    end

    def navigations
      build_i18n_navigations unless @i18n_navigations
      @navigations
    end

    def navigations=(navigations)
      @navigations = navigations
    end

    # config/navigations/<name>.<locale>.yml holds one locale's navigation; <name>.yml holds the pages
    # of every locale, with titles and slugs from I18n (built on first use, see #i18n_pages).
    def initialize_navigations
      Dir[File.join(Rails.root, Seiten.config[:config_dir], "*.yml")].each do |file|
        id = File.basename(file, '.yml')
        if id.include?('.')
          name, locale = id.split('.', 2)
          navigation = Seiten::Navigation.new(name: name, locale: locale, dir: File.join(Rails.root, Seiten.config[:pages_dir], name, locale))
          navigation.page_collection.build(pages: YAML.load_file(navigation.config))
          @navigations << navigation
        else
          @i18n_files[id] = file
        end
      end
    end

    # Drops the navigations built from I18n, so they're built again with the current translations
    # (on every code or translation reload in development).
    def reset_i18n_navigations!
      @i18n_lock.synchronize do
        @navigations -= @i18n_navigations if @i18n_navigations
        @i18n_navigations = nil
      end
    end

    private

    def build_i18n_navigations
      @i18n_lock.synchronize do
        return if @i18n_navigations

        @i18n_navigations = @i18n_files.flat_map do |name, file|
          structure = YAML.load_file(file)
          I18n.available_locales.map do |locale|
            navigation = Seiten::Navigation.new(name: name, locale: locale, config: file, dir: File.join(Rails.root, Seiten.config[:pages_dir], name, locale.to_s))
            navigation.page_collection.build(pages: i18n_pages(structure, locale, [Seiten.config[:i18n_scope], name]))
            navigation
          end
        end
        @navigations.concat(@i18n_navigations)
      end
    end

    # The pages of a locale: every page names its `key`; its title and slug are the translations
    # <i18n_scope>.<navigation>.<parent keys…>.<key>.title and .slug (the slug defaults to the
    # parameterized title). The page's key becomes its full key, e.g. "account.manage", which is the
    # same page in every locale.
    def i18n_pages(nodes, locale, scope)
      nodes.map do |node|
        node = node.dup
        key = node['key'] or raise Errors::PageError, "Every page of #{scope[1]}.yml needs a key"
        page_scope = [*scope, key.to_s]
        title = I18n.t('title', scope: page_scope, locale: locale, default: nil)
        slug = I18n.t('slug', scope: page_scope, locale: locale, default: nil)
        raise Errors::PageError, "#{page_scope.join('.')} needs a title or a slug in #{locale}" unless title || slug || node.key?('url')

        node['title'] = title
        node['url'] = slug if slug && !node.key?('url')
        node['key'] = page_scope.drop(2).join('.')
        node['nodes'] = i18n_pages(node['nodes'], locale, page_scope) if node['nodes']
        node
      end
    end
  end

  ActiveSupport.on_load(:action_controller) do
    include Helpers::Current
  end
end
