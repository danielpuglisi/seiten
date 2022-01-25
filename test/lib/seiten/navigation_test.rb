require 'test_helper'

class Seiten::NavigationTest < ActiveSupport::TestCase

  def navigation
    @navigation ||= Seiten::Navigation.new(
      name: 'test',
      locale: 'en'
    )
  end

  test '::find_by' do
    assert_equal 'application.en', Seiten::Navigation.find_by(name: 'application', locale: 'en').id
    assert_equal 'application.de', Seiten::Navigation.find_by(name: 'application', locale: 'de').id
    assert_equal 'application.en', Seiten::Navigation.find_by(locale: 'en').id
    assert_equal 'application.de', Seiten::Navigation.find_by(locale: 'de').id
  end

  test '::where' do
    assert_equal ['application.de', 'application.en'], Seiten::Navigation.where(name: 'application').map(&:id).sort
  end


  test '#id' do
    nav = Seiten::Navigation.new(name: 'site', locale: 'en')
    assert_equal 'site.en', nav.id
  end

  test '#pages' do
    nav = Seiten::Navigation.new(name: 'test', locale: 'en')
    pages = Seiten::PageCollection.new
    nav.page_collection = pages

    assert_equal pages, nav.pages
  end

  test '#pages=' do
    page = Seiten::Page.new

    navigation.pages = [page]

    assert_equal page.navigation_id, navigation.id
    assert_equal [page], navigation.pages.all
  end
end
