require 'test_helper'

class CustomPagesController < ActionController::Metal
  include Seiten::ControllerHelpers::Current
end

class HelperMethodsTest < ActionController::TestCase
  tests CustomPagesController

  test 'includes Seiten::ControllerHelpers::Current' do
    assert_includes @controller.class.ancestors, Seiten::ControllerHelpers::Current
  end

  test 'does not respond_to helper_method' do
    refute_respond_to @controller.class, :helper_method
  end

  test 'defines methods like current_page' do
    assert_respond_to @controller, :current_page
  end

  test 'defines methods like current_navigation' do
    assert_respond_to @controller, :current_navigation
  end
end
