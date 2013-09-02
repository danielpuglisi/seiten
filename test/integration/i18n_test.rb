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
    visit "/produkte"
    assert has_content?("Das ist die Produkte Seite")
  end

  def test_loads_de_navigation
    I18n.locale = :de
    assert_equal File.join(Rails.root, "config", "navigation.de.yml"), Seiten::PageStore.new.storage_file
  end

  def test_loads_en_navigation
    I18n.locale = :en
    assert_equal File.join(Rails.root, "config", "navigation.en.yml"), Seiten::PageStore.new.storage_file
  end

  def test_loads_navigation_without_locale_if_not_found
    I18n.locale = :fr
    assert_equal File.join(Rails.root, "config", "navigation.yml"), Seiten::PageStore.new.storage_file
  end
end
