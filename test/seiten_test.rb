require 'test_helper'

class SeitenTest < ActiveSupport::TestCase

  def test_returns_page_storage_path
    assert_equal File.join(Rails.root, "app/pages/home.html.erb"), Seiten.storage_path(filename: "home.html.erb")
    assert_equal File.join(Rails.root, "app/pages/en/contact.html.erb"), Seiten.storage_path(filename: "contact.html.erb", locale: "en")
  end
end
