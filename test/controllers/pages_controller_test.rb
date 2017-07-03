require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should not set current page on pages controller" do
    get :secret
    assert_nil @controller.instance_eval { @current_page }
  end
end
