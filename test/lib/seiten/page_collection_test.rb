require 'test_helper'

class Seiten::PageCollectionTest < ActiveSupport::TestCase
  def navigation
    @navigation ||= Seiten::Navigation.new(name: :test, locale: :en)
  end

  def page_collection
    @page_collection ||= Seiten::PageCollection.new(
      navigation_id: 'test.en',
      pages: [
        Seiten::Page.new(navigation_id: 'test.en', id: 1),
        Seiten::Page.new(navigation_id: 'test.en', id: 2, parent_id: 1),
        Seiten::Page.new(navigation_id: 'test.en', id: 3, parent_id: 1),
        Seiten::Page.new(navigation_id: 'test.en', id: 4),
        Seiten::Page.new(navigation_id: 'test.en', id: 5)
      ]
    )
  end

  setup do
    Seiten.navigations << navigation
  end

  teardown do
    Seiten.navigations = Seiten.navigations - [navigation]
  end

  test '#navigation' do
    assert_equal navigation, page_collection.navigation
  end

  test '#all' do
    assert_equal [1,2,3,4,5], page_collection.all.map(&:id)
  end

  test '#find' do
    assert_equal 3, page_collection.find(3).id
  end

  test '#find_by' do
    assert_equal 2, page_collection.find_by(id: 2).id
    assert_equal 3, page_collection.find_by(id: 3, parent_id: 1).id
    assert_nil page_collection.find_by(id: 2, parent_id: 2)
  end

  test '#where' do
    assert_equal [1], page_collection.where(id: 1).map(&:id)
    assert_equal [2,3], page_collection.where(parent_id: 1).map(&:id)
    assert_equal [], page_collection.where(parent_id: 2)
  end

  test '#new' do
    page = page_collection.new(id: 6)
    assert_equal 6, page.id
    assert_equal 'test.en', page.navigation_id
    assert_equal [1,2,3,4,5,6], page_collection.all.map(&:id)
  end
end
