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
end
