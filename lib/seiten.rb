require 'seiten/engine'
require 'seiten/page_store'
require 'seiten/page'
require 'seiten/routes_helper'

module Seiten

  @config = {
    default_storage_type: :yaml,
    default_storage_file: File.join('config', 'navigation'),
    default_storage_directory: File.join('app', 'pages'),
    root_page_filename: "home"
  }

  def self.config
    @config
  end

  module Controllers
    autoload :Helpers, 'seiten/controllers/helpers'
  end

  ActiveSupport.on_load(:action_controller) do
    include Controllers::Helpers
  end
end
