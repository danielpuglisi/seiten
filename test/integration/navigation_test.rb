require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest

  def test_returns_navigation
    visit "/"
    assert has_content?("Home")
    assert has_content?("Products")
    assert has_content?("Kreatify")
    assert has_content?("Ruvetia")
    assert has_content?("About")
    assert has_content?("Contact")
  end
end
