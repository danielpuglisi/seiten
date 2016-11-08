require 'test_helper'

class SeitenTest < ActiveSupport::TestCase

  def test_returns_page_storage_path
    Seiten::PageStore.set_current_page_store(storage_language: :en)
    assert_equal File.join(Rails.root, "app/pages/en/home.html.erb"), Seiten::PageStore.current.file_path(filename: "home.html.erb")
    Seiten::PageStore.set_current_page_store(storage_language: :de)
    assert_equal File.join(Rails.root, "app/pages/de/kontakt.html.erb"), Seiten::PageStore.current.file_path(filename: "kontakt.html.erb")
  end
end
