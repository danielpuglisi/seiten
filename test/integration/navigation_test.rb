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
    assert_select '.navigation__item--active', count: 1
    assert_select 'title', 'My awesome Web Agency'
  end

  def test_returns_sub_navigation
    get '/about/partners'
    assert_select 'a', 'Daniel Puglisi'
    assert_select 'a', 'Codegestalt'
    assert_select 'a', 'Kreatify'
    assert_select '.navigation__item--active', count: 2
    assert_select 'title', 'Partners'
  end

  def test_returns_breadcrumb_navigation
    get '/about/our-team/switzerland'
    assert_select '.breadcrumb a', 'About'
    assert_select '.breadcrumb a', 'Our Team'
    assert_select '.breadcrumb a', 'Switzerland'
    assert_select '.navigation__item--active', count: 2
    assert_select '.breadcrumb__item--current', count: 1
    assert_select 'title', 'Switzerland'
  end

  def test_returns_page_with_navigation_which_is_not_defined_in_navigation_config
    get '/secret'
    assert_response :success
    assert_select 'p', 'pages#secret'
    assert_select '.navigation__item--active', count: 0
    assert_select 'title', nil
  end

  def test_returns_current_page_of_custom_controller
    get '/blog'
    assert_select 'title', 'Blog'
    assert_select 'p', 'posts#index'
    assert_select '.navigation__item--active', count: 1
    assert_select '.navigation__item--active a', text: 'Blog'
  end
end
