require 'test_helper'

class Seiten::NavigationTest < ActiveSupport::TestCase

  test '.id' do
    nav = Seiten::Navigation.new(name: :site, locale: :en)
    assert_equal 'site.en', nav.id
  end

  test '#find_by' do
    site_en = Seiten::Navigation.new(name: :site, locale: :en)
    site_de = Seiten::Navigation.new(name: :site, locale: :de)

    Seiten.navigations << site_en
    Seiten.navigations << site_de

    assert_equal site_en, Seiten::Navigation.find_by(name: :site, locale: :en)
    assert_equal site_de, Seiten::Navigation.find_by(name: :site, locale: :de)
    assert_equal site_de, Seiten::Navigation.find_by(locale: :de)
    assert_equal site_en, Seiten::Navigation.find_by(locale: :en)
  end

  # # TODO: Split into two tests
  # def test_sets_and_returns_current_page_store
  #   page_store = Seiten::PageStore.find_by(storage_language: :de)
  #   Seiten::PageStore.set_current_page_store(storage_language: :de)
  #   assert_equal page_store, Seiten::PageStore.current
  #   Seiten::PageStore.set_current_page_store(storage_language: :en)
  # end

  # def test_find_by_with_one_argument
  #   page_store = Seiten::PageStore.find_by(storage_language: :de)
  #   assert_equal File.join(Rails.root, "config", "navigation", "de.yml"), page_store.storage_file
  # end

  # def test_find_by_with_multiple_arguments
  #   page_store = Seiten::PageStore.find_by(storage_language: :de, storage_file: File.join(Rails.root, "config", "navigation", "de.yml"))
  #   assert_equal File.join(Rails.root, "config", "navigation", "de.yml"), page_store.storage_file
  # end

  # TODO: Write more tests
end
