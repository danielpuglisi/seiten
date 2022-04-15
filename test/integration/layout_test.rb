require 'test_helper'

class LayoutTest < ActionDispatch::IntegrationTest
  def test_returns_default_layout
    get '/about/works'
    assert_select 'p', 'Default Layout'
  end

  def test_returns_home_layout
    get '/'
    assert_select 'p', 'Home Layout'
  end

  def test_returns_inherited_layout
    get '/products/logo-design'
    assert_select 'p', 'Products Layout'
  end

  def test_returns_no_inherited_layout
    get '/about/our-team/switzerland'
    assert_select 'p', 'Default Layout'
    get '/contact'
    assert_select 'p', 'Default Layout'
  end
end
