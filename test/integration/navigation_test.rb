require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest

  def test_should_ignore_active_storage_routes
    assert_raise ActionController::RoutingError do
      get '/rails/active_storage/test'
    end
  end

  def test_should_raise_seiten_routing_error
    assert_raise Seiten::Errors::RoutingError do
      get '/non-existing-route'
    end
  end

  def test_returns_2_level_deep_navigation
    get '/'
    assert_select 'a', 'Home'
    assert_select 'a', 'Products'
    assert_select 'a', 'Logo Design'
    assert_select 'a', 'Web Development'
    assert_select 'a', 'Hire us'
    assert_select 'a', 'About'
    assert_select 'a', 'Our Team'
    assert_select 'a', 'Works'
    assert_select 'a', 'Partners'
    assert_select 'a', 'Contact'
    assert_select 'a', { count: 0, text: 'Daniel Puglisi' }
    assert_select 'a', { count: 0, text: 'Codegestalt' }
    assert_select 'a', { count: 0, text: 'Kreatify' }
  end

  def test_returns_sub_navigation
    get "/about/partners"
    assert_select 'a', 'Daniel Puglisi'
    assert_select 'a', 'Codegestalt'
    assert_select 'a', 'Kreatify'
  end
end

  # def test_returns_home_url
  #   visit "/contact"
  #   assert_equal "/contact", current_path
  #   click_link "Home"
  #   assert_equal "/", current_path
  # end

#   def test_returns_breadcrumb_navigation
#     visit "/about/our-team/switzerland"
#     assert has_content?("> About")
#     assert has_content?("> Our Team")
#     assert has_content?("> Switzerland")
#   end

#   def test_returns_clicked_breadcrumb_page
#     visit "/about/our-team/switzerland"
#     find(".breadcrumb a", text: "Our Team").click
#     assert_equal "/about/our-team", current_path
#   end

#   def test_returns_clicked_navigation_page
#     visit "/"
#     click_link "Web Development"
#     assert_equal "/products/web-development", current_path
#   end

#   def test_returns_external_links
#     visit "/about/partners"
#     assert has_xpath?("//a[@href='http://danielpuglisi.com']")
#   end

#   def test_returns_page_with_navigation_which_is_not_defined_in_navigation_config
#     visit "/secret"
#     assert_equal 200, status_code
#     assert has_content?("This is a secret page")
#     assert has_xpath?("//li[@class='inactive']/a[@href='/']", text: "Home"), "Home page is active but should be inactive"
#     assert_equal "", page.title
#   end

#   def test_returns_root_page_specific_values_set_in_application_controller
#     visit "/"
#     assert_equal "My awesome Web Agency", page.title
#   end

#   def test_returns_current_page_of_blog_page
#     visit "/blog"
#     assert_equal "Blog", page.title
#     assert has_content?("posts index")
#   end
