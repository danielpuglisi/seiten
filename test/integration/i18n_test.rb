require 'test_helper'

class I18nTest < ActionDispatch::IntegrationTest

  def test_returns_page_in_root_if_not_found_in_locale_directory
    visit "/i18n"
    assert_equal 200, status_code
    assert has_content?("I18n is in root")
  end

  def test_returns_products_page_in_en_directory
    I18n.locale = :en
    visit "/products"
    assert has_content?("This is the products page")
  end

  def test_returns_products_page_in_de_directory
    I18n.locale = :de
    visit "/products"
    assert has_content?("Das ist die Produkte Seite")
  end
end
