require 'test_helper'

class Seiten::HTML::HelpersTest < ActiveSupport::TestCase

  def navigation
    @navigation ||= Seiten::Navigation.find_by(id: 'application.en')
  end

  def current_page
    @current_page ||= navigation.pages.find(1)
  end

  def helpers
    Seiten::HTML::Helpers
  end

  test '#build_page_modifiers' do
    page_1 = navigation.pages.new(id: 99)
    page_2 = navigation.pages.new(id: 200, parent_id: 99)
    assert_equal [:parent], helpers.build_page_modifiers(page_1, nil)
    assert_equal [], helpers.build_page_modifiers(page_2, nil)

    assert_equal [:parent, :active, :current], helpers.build_page_modifiers(page_1, page_1)
    assert_equal [], helpers.build_page_modifiers(page_2, page_1)

    assert_equal [:parent, :active, :expanded], helpers.build_page_modifiers(page_1, page_2)
    assert_equal [:active, :current], helpers.build_page_modifiers(page_2, page_2)
  end

  test '#build_classes' do
    class_options = Seiten.config[:helpers][:navigation][:html][:class].dup

    assert_equal 'navigation', helpers.build_classes(class_options: class_options)
    assert_equal 'navigation__item', helpers.build_classes(:item, class_options: class_options)
    assert_equal 'navigation__item navigation__item--active', helpers.build_classes(:item, modifiers: [:active], class_options: class_options)
    assert_equal 'navigation__item navigation__item--active navigation__item--parent', helpers.build_classes(:item, modifiers: [:active, :parent], class_options: class_options)
    assert_equal 'navigation__nodes navigation__nodes--active navigation__nodes--parent', helpers.build_classes(:nodes, modifiers: [:active, :parent], class_options: class_options)

    # Works with custom html class config
    class_options[:base] = 'navbar'
    class_options[:item] = 'navbar-item'
    class_options[:nodes] = 'navbar-dropdown'
    class_options[:mod_base] = 'is'
    class_options[:mod_sep] = '-'
    assert_equal 'navbar', helpers.build_classes(class_options: class_options)
    assert_equal 'navbar-item', helpers.build_classes(:item, class_options: class_options)
    assert_equal 'navbar-item is-active', helpers.build_classes(:item, modifiers: [:active], class_options: class_options)
    assert_equal 'navbar-item is-active is-parent', helpers.build_classes(:item, modifiers: [:active, :parent], class_options: class_options)
    assert_equal 'navbar-dropdown is-active is-parent', helpers.build_classes(:nodes, modifiers: [:active, :parent], class_options: class_options)

    # Merges extension-class
    assert_equal 'navbar-item is-active is-parent extension-class', helpers.build_classes(:item, modifiers: [:active, :parent], merge: 'extension-class', class_options: class_options)
  end
end
