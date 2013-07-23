require 'seiten/engine'
require 'seiten/page_store'
require 'seiten/page'

module Seiten

  @config = {
    storage_type: :yaml,
    storage_file: File.join('config', 'navigation.yml'),
    storage_directory: File.join('app', 'pages')
  }

  def self.config
    @config
  end
end
