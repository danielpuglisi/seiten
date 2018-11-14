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
    assert_equal "navigation__item", build_seiten_element_classes(:item)
    assert_equal "navigation__item navigation__item--active", build_seiten_element_classes(:item, [:active])
    assert_equal "navigation__item navigation__item--active navigation__item--parent", build_seiten_element_classes(:item, [:active, :parent])
    assert_equal "navigation__nodes navigation__nodes--active navigation__nodes--parent", build_seiten_element_classes(:nodes, [:active, :parent])

    # Works with custom html class config
    class_options[:base] = 'navbar'
    class_options[:item] = 'navbar-item'
    class_options[:nodes] = 'navbar-dropdown'
    class_options[:mod_base] = "is"
    class_options[:mod_sep] = '-'
    @seiten_navigation_options = Hash[:class, class_options]
    assert_equal "navbar", build_seiten_element_classes
    assert_equal "navbar-item", build_seiten_element_classes(:item)
    assert_equal "navbar-item is-active", build_seiten_element_classes(:item, [:active])
    assert_equal "navbar-item is-active is-parent", build_seiten_element_classes(:item, [:active, :parent])
    assert_equal "navbar-dropdown is-active is-parent", build_seiten_element_classes(:nodes, [:active, :parent])

    # Merges extension-class
    assert_equal "navbar-item is-active is-parent extension-class", build_seiten_element_classes(:item, [:active, :parent], merge: 'extension-class')
  end
end
