require 'sticky_pages/page_store'
require 'sticky_pages/page'

module StickyPages

  @config = {
    storage_type: :yaml,
    storage_file: File.join('config', 'navigation.yml')
  }

  def self.config
    @config
  end
end
