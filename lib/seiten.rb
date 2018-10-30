require 'seiten/engine'
require 'seiten/navigation'
require 'seiten/page'
require 'seiten/page_collection'
require 'seiten/page_collection_builder'
require 'seiten/slug_builder'
require 'seiten/breadcrumb_builder'
require 'seiten/routes_helper'

module Seiten

  @config = {
    config_dir: File.join('config', 'navigations'),
    pages_dir:  File.join('app', 'pages'),
    root_page: 'home',
    helpers: {
      navigation: {
        html: {
          class: 'navigation',
          item_class: 'navigation__item',
          nodes_class: 'navigation__children',
          parent_class: 'navigation__item--parent',
          active_class: 'navigation__item--active',
          inactive_class: 'navigation__item--inactive',
          current_class: 'navigation__item--current',
          expanded_class: 'navigation__item--expanded'
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

  module Controllers
    autoload :Helpers, 'seiten/controllers/helpers'
  end

  ActiveSupport.on_load(:action_controller) do
    include Controllers::Helpers
  end
end
