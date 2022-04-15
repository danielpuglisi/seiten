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

  class << self
    def config
      @config
    end

    def navigations
      @navigations
    end

    def navigations=(navigations)
      @navigations = navigations
    end

    def initialize_navigations
      if File.directory?(File.join(Rails.root, Seiten.config[:config_dir]))
        Dir[File.join(Rails.root, Seiten.config[:config_dir], "*.yml")].each do |file|
          id     = File.basename(file, '.yml')
          name   = id.gsub(/\..*/, '')
          locale = id.gsub(/.*\./, '')
          navigation = Seiten::Navigation.new(name: name, locale: locale, dir: File.join(Rails.root, Seiten.config[:pages_dir], name, locale))
          navigation.page_collection.build(pages: YAML.load_file(navigation.config))
          Seiten.navigations << navigation
        end
      else
        # TODO: Raise exception
      end
    end
  end

  ActiveSupport.on_load(:action_controller) do
    include Helpers::Current
  end
end
