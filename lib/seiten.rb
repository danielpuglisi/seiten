require 'seiten/engine'
require 'seiten/navigation'
require 'seiten/page'
require 'seiten/slug_builder'
require 'seiten/routes_helper'

module Seiten

  @config = {
    config_dir: File.join('config', 'navigations'),
    pages_dir:  File.join('app', 'pages')
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
          Seiten.navigations << Seiten::Navigation.new(name: name, locale: locale, dir: File.join(Rails.root, Seiten.config[:pages_dir], name, locale))
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
