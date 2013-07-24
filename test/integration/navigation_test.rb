require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest

  def test_returns_2_level_deep_navigation
    p Seiten.config[:storage_directory]
    visit "/"
    assert has_content?("Home")
    assert has_content?("Products")
    assert has_content?("Logo Design")
    assert has_content?("Web Development")
    assert has_content?("Hire us")
    assert has_content?("About")
    assert has_content?("Our Team")
    assert has_content?("Works")
    assert has_content?("Partners")
    assert has_content?("Contact")
  end

  def test_does_not_return_3_level_deep_pages
    visit "/"
    assert !has_content?("Daniel Puglisi")
    assert !has_content?("Codegestalt")
    assert !has_content?("Kreatify")
  end

  def test_redirects_to_first_child_page
    visit "/about"
    assert_equal "/about/our-team", current_path
  end

  def test_returns_sub_navigation
    visit "/about/partners"
    assert has_content?("Daniel Puglisi")
    assert has_content?("Codegestalt")
    assert has_content?("Kreatify")
  end

  def test_returns_breadcrumb_navigation
    visit "/about/our-team/switzerland"
    assert has_content?("> About")
    assert has_content?("> Our Team")
    assert has_content?("> Switzerland")
  end

  def test_returns_clicked_breadcrumb_page
    visit "/about/our-team/switzerland"
    find(".breadcrumb a", text: "Our Team").click
    assert_equal "/about/our-team", current_path
  end

  def test_returns_clicked_navigation_page
    visit "/"
    click_link "Web Development"
    assert_equal "/products/web-development", current_path
  end

  def test_redirects_to_linked_page
    visit "/"
    click_link "Hire us"
    assert_equal "/contact", current_path
  end

  def test_returns_external_links
    visit "/about/partners"
    assert has_xpath?("//a[@href='http://danielpuglisi.com']")
  end

  def test_returns_page_with_navigation_which_is_not_defined_in_navigation_config
    visit "/secret"
    assert_equal 200, status_code
    has_content?("This is a secret page")
  end
end
