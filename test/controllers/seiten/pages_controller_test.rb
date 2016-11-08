require 'test_helper'

class Seiten::PagesControllerTest < ActionController::TestCase
  test "should set current page when params[:page] is empty" do
    get :show
    assert_equal Seiten::Page.find_by_slug(""), @controller.instance_eval { @current_page }
  end

  test "should set 'products' page as current page" do
    get :show, params: { page: :products }
    assert_equal Seiten::Page.find_by_slug("products"), @controller.instance_eval { @current_page }
  end

  test "should get all defined pages" do
  end
end
