require 'test_helper'

class SeitenHelperTest < ActionView::TestCase

  def navigation
    @navigation ||= Seiten::Navigation.new(name: :test, locale: :en)
  end

  def current_page
    @current_page
  end

  setup do
    Seiten.navigations << navigation
  end

  teardown do
    Seiten.navigations = Seiten.navigations - [navigation]
  end

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

    # Refer page
    page = Seiten::Page.new(refer: '/about/our-team')
    assert_equal '/about/our-team', url_for_seiten_page(page)
  end

  test '#seiten_page_element' do
  end

  test '#build_seiten_page_modifiers' do
    page_1 = navigation.pages.new(id: 1)
    page_2 = navigation.pages.new(id: 2, parent_id: 1)
    assert_equal [:parent], build_seiten_page_modifiers(page_1)
    assert_equal [], build_seiten_page_modifiers(page_2)

    @current_page = page_1
    assert_equal [:parent, :active, :current], build_seiten_page_modifiers(page_1)
    assert_equal [], build_seiten_page_modifiers(page_2)

    @current_page = page_2
    assert_equal [:parent, :active, :expanded], build_seiten_page_modifiers(page_1)
    assert_equal [:active, :current], build_seiten_page_modifiers(page_2)
  end

  test '#build_seiten_element_classes' do
    class_options = Seiten.config[:helpers][:navigation][:html][:class]
    @seiten_navigation_options = Hash[:class, class_options]

    assert_equal "navigation", build_seiten_element_classes
    assert_equal "navigation__item", build_seiten_element_classes(:page)
    assert_equal "navigation__item navigation__item--active", build_seiten_element_classes(:page, [:active])
    assert_equal "navigation__item navigation__item--active navigation__item--parent", build_seiten_element_classes(:page, [:active, :parent])

    class_options[:base] = 'navbar'
    class_options[:mod_base] = "is"
    class_options[:separators][:element] = '-'
    class_options[:separators][:modifier] = '-'
    @seiten_navigation_options = Hash[:class, class_options]
    assert_equal "navbar", build_seiten_element_classes
    assert_equal "navbar-item", build_seiten_element_classes(:page)
    assert_equal "navbar-item is-active", build_seiten_element_classes(:page, [:active])
    assert_equal "navbar-item is-active is-parent", build_seiten_element_classes(:page, [:active, :parent])
  end
end
