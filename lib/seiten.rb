require 'seiten/engine'
require 'seiten/navigation'
require 'seiten/page'
require 'seiten/page_collection'
require 'seiten/page_collection_builder'
require 'seiten/slug_builder'
require 'seiten/breadcrumb_builder'
require 'seiten/routes_helper'
require 'seiten/controller_helpers/current'
require 'seiten/controller_helpers/backend'
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
    helpers: {
      navigation: {
        html: {
          class: {
            base: 'navigation',
            item: 'navigation__item',
            nodes: 'navigation__nodes',
            mod_base: nil, # if nil we use the main class combined with the element class
            mod_sep: '--', # modifier separator
            modifiers: {
              parent: 'parent',
              active: 'active',
              current: 'current',
              expanded: 'expanded'
            }
          }
        }
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
          navigation = Seiten::Navigation.new(name: name.to_sym, locale: locale.to_sym, dir: File.join(Rails.root, Seiten.config[:pages_dir], name, locale))
          navigation.page_collection.build(pages: YAML.load_file(navigation.config))
          Seiten.navigations << navigation
        end
      else
        # TODO: Raise exception
      end
    end
  end

  ActiveSupport.on_load(:action_controller) do
    include ControllerHelpers::Current
  end
end
