require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  test "should set current page on posts controller" do
    get :index
    assert_equal Seiten::Page.find_by_slug("blog"), @controller.instance_eval { @current_page }
  end
end
