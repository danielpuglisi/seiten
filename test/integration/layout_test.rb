require 'test_helper'

class LayoutTest < ActionDispatch::IntegrationTest

  def test_returns_default_layout
    visit "/about/works"
    assert has_content?("Default Layout"), "not rendered default layout"
  end

  def test_returns_home_layout
    visit "/"
    assert has_content?("Home Layout"), "not rendered home layout"
  end

  def test_returns_inherited_layout
    visit "/products/logo-design"
    assert has_content?("Products Layout"), "not rendered inherited layout"
  end

  def test_returns_no_inherited_layout
    visit "/about/our-team/switzerland"
    assert has_content?("Default Layout"), "not rendered default layout"
    visit "/contact"
    assert has_content?("Default Layout"), "not rendered default layout"
  end
end
