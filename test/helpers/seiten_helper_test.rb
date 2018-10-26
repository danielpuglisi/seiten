require 'test_helper'

class SeitenHelperTest < ActionView::TestCase

  test '#seiten_navigation' do
    skip
  end

  test '#seiten_breadcrumb' do
    skip
  end

  test '#link_to_seiten_page' do
    skip
  end

  test '#url_for_seiten_page' do
    # Regular page with custom navigation_id
    controller.params = { navigation_id: 'help' }
    page = Seiten::Page.new(slug: 'about/products')
    assert_equal [:seiten, 'help', :page, page: 'about/products'], url_for_seiten_page(page)

    # Regular page
    controller.params = {}
    page = Seiten::Page.new(slug: 'about/products')
    assert_equal [:seiten, nil, :page, page: 'about/products'], url_for_seiten_page(page)

    # External page
    page = Seiten::Page.new(slug: 'https://codegestalt.com')
    assert_equal 'https://codegestalt.com', url_for_seiten_page(page)

    # Anchor page
    page = Seiten::Page.new(slug: nil)
    assert_equal '#', url_for_seiten_page(page)
  end

  test '#seiten_navigation_page_class' do
    skip
  end
end
