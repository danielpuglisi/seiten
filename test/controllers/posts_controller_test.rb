require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  def navigation
    @navigation ||= Seiten::Navigation.find_by(name: :application, locale: :en)
  end

  test "should set current page on posts controller" do
    get :index
    assert_equal navigation.pages.find_by(slug: "blog"), @controller.instance_eval { @current_page }
  end
end
