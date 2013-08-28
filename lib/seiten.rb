require 'seiten/engine'
require 'seiten/page_store'
require 'seiten/page'
require 'seiten/routes_helper'

module Seiten

  @config = {
    storage_type: :yaml,
    storage_file: File.join('config', 'navigation.yml'),
    storage_directory: File.join('app', 'pages')
  }

  def self.config
    @config
  end

  def self.storage_path(options={})
    File.join(Rails.root, config[:storage_directory], options[:locale].to_s, options[:filename])
  end

  module Controllers
    autoload :Helpers, 'seiten/controllers/helpers'
  end

  ActiveSupport.on_load(:action_controller) do
    include Controllers::Helpers
  end
end
