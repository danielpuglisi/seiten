require 'test_helper'

class CurrentPageControllerTest < ActionController::TestCase

  test "should set current page when params[:page] is empty" do
    @controller = Seiten::PagesController.new
    get :show
    assert_equal Seiten::Page.find_by_slug(""), @controller.instance_eval { @current_page }
  end

  test "should set 'products' page as current page" do
    @controller = Seiten::PagesController.new
    get :show, page: "products"
    assert_equal Seiten::Page.find_by_slug("products"), @controller.instance_eval { @current_page }
  end

  test "should set current page on posts controller" do
    @controller = PostsController.new
    get :index
    assert_equal Seiten::Page.find_by_slug("blog"), @controller.instance_eval { @current_page }
  end

  test "should no set current page on pages controller" do
    @controller = PagesController.new
    get :secret
    assert_equal nil, @controller.instance_eval { @current_page }
  end
end
