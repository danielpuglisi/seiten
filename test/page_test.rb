require 'test_helper'

class PageTest < Test::Unit::TestCase

  def test_returns_correct_number_of_page_objects
    pages = StickyPages::Page.all
    assert_equal 10, pages.count
  end

  def test_returns_page_title
    assert_equal "Home", StickyPages::Page.find(1).title
  end

  def test_returns_page_slug
    assert_equal "/", StickyPages::Page.find(1).slug
  end

  def test_returns_parent_page
    page = StickyPages::Page.find(3)
    assert_equal StickyPages::Page.find(2).title, page.parent.title
  end

  def test_returns_children_pages
    page = StickyPages::Page.find(2)
    assert_equal ["Kreatify", "Ruvetia"], page.children.map(&:title)
  end

  def test_returns_true_if_page_is_child_of_parent
    child = StickyPages::Page.find(3)
    assert_equal true, StickyPages::Page.find(2).parent_of?(child)
  end

  def test_returns_true_if_page_child_is_deeply_nested
    child = StickyPages::Page.find(5)
    assert_equal true, StickyPages::Page.find(2).parent_of?(child)
  end

  def test_returns_false_if_page_is_not_child_of_parent
    wrong_child = StickyPages::Page.find(1)
    assert_equal false, StickyPages::Page.find(2).parent_of?(wrong_child)
  end

  def test_returns_true_for_active_page
    active_page = StickyPages::Page.find(1)
    assert_equal true, active_page.active?(active_page)
  end

  def test_returns_true_for_parent_of_active_page
    active_page = StickyPages::Page.find(3)
    assert_equal true, StickyPages::Page.find(2).active?(active_page)
  end

  def test_returns_false_for_not_active_page
    active_page = StickyPages::Page.find(1)
    assert_equal false, active_page.active?(StickyPages::Page.find(2))
  end

  def test_finds_page_by_slug
    page = StickyPages::Page.find_by_slug("/products/ruvetia")
    assert_equal "Ruvetia", page.title
  end
end
