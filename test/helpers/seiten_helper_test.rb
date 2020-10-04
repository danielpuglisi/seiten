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

    assert_equal "navigation", build_seiten_element_classes(class_options: class_options)
    assert_equal "navigation__item", build_seiten_element_classes(:item, class_options: class_options)
    assert_equal "navigation__item navigation__item--active", build_seiten_element_classes(:item, modifiers: [:active], class_options: class_options)
    assert_equal "navigation__item navigation__item--active navigation__item--parent", build_seiten_element_classes(:item, modifiers: [:active, :parent], class_options: class_options)
    assert_equal "navigation__nodes navigation__nodes--active navigation__nodes--parent", build_seiten_element_classes(:nodes, modifiers: [:active, :parent], class_options: class_options)

    # Works with custom html class config
    class_options[:base] = 'navbar'
    class_options[:item] = 'navbar-item'
    class_options[:nodes] = 'navbar-dropdown'
    class_options[:mod_base] = "is"
    class_options[:mod_sep] = '-'
    assert_equal "navbar", build_seiten_element_classes(class_options: class_options)
    assert_equal "navbar-item", build_seiten_element_classes(:item, class_options: class_options)
    assert_equal "navbar-item is-active", build_seiten_element_classes(:item, modifiers: [:active], class_options: class_options)
    assert_equal "navbar-item is-active is-parent", build_seiten_element_classes(:item, modifiers: [:active, :parent], class_options: class_options)
    assert_equal "navbar-dropdown is-active is-parent", build_seiten_element_classes(:nodes, modifiers: [:active, :parent], class_options: class_options)

    # Merges extension-class
    assert_equal "navbar-item is-active is-parent extension-class", build_seiten_element_classes(:item, modifiers: [:active, :parent], merge: 'extension-class', class_options: class_options)
  end
end
