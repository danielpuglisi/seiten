require 'test_helper'

class PageTest < Test::Unit::TestCase

  def test_returns_correct_number_of_page_objects
    pages = Seiten::Page.all
    assert_equal 15, pages.count
  end

  def test_returns_page_title
    assert_equal "Home", Seiten::Page.find(1).title
  end

  def test_returns_page_slug
    assert_equal "/", Seiten::Page.find(1).slug
  end

  def test_returns_page_layout
    assert_equal "home", Seiten::Page.find(1).layout
  end

  def test_returns_parent_page
    page = Seiten::Page.find(3)
    assert_equal Seiten::Page.find(2).title, page.parent.title
  end

  def test_returns_children_pages
    page = Seiten::Page.find(2)
    assert_equal ["Logo Design", "Web Development", "Hire us"], page.children.map(&:title)
  end

  def test_returns_true_if_page_is_child_of_parent
    child = Seiten::Page.find(3)
    assert_equal true, Seiten::Page.find(2).parent_of?(child)
  end

  def test_returns_true_if_page_child_is_deeply_nested
    child = Seiten::Page.find_by_slug("/about/our-team")
    assert_equal true, Seiten::Page.find_by_slug("/about").parent_of?(child)
  end

  def test_returns_false_if_page_is_not_child_of_parent
    wrong_child = Seiten::Page.find(1)
    assert_equal false, Seiten::Page.find(2).parent_of?(wrong_child)
  end

  def test_returns_true_for_active_page
    active_page = Seiten::Page.find(1)
    assert_equal true, active_page.active?(active_page)
  end

  def test_returns_true_for_parent_of_active_page
    active_page = Seiten::Page.find(3)
    assert_equal true, Seiten::Page.find(2).active?(active_page)
  end

  def test_returns_false_for_not_active_page
    active_page = Seiten::Page.find(1)
    assert_equal false, active_page.active?(Seiten::Page.find(2))
  end

  def test_finds_page_by_slug
    page = Seiten::Page.find_by_slug("/products/logo-design")
    assert_equal "Logo Design", page.title
  end

  def test_returns_nil_for_active_method_when_current_page_is_nil
    assert_equal nil, Seiten::Page.find(1).active?(nil)
  end
end
