require 'test_helper'

class RedirectTest < ActionDispatch::IntegrationTest

  def test_redirects_to_specified_page
    visit "/"
    click_link "Hire us"
    assert_equal "/contact", current_path
  end

  def test_redirects_to_first_child_page
    visit "/about"
    assert_equal "/about/our-team", current_path
  end
end
