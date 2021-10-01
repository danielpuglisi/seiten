require 'test_helper'

class CustomPagesController < ActionController::Base
  include Seiten::ControllerHelpers::Backend
end

class CurrentHelperMethodsTest < ActionController::TestCase
  tests CustomPagesController

  test 'includes Seiten::ControllerHelpers::Current' do
    assert_includes @controller.class.ancestors, Seiten::ControllerHelpers::Current
  end

  test 'includes Seiten::ControllerHelpers::Backend' do
    assert_includes @controller.class.ancestors, Seiten::ControllerHelpers::Backend
  end

  test 'defines methods like current_navigation' do
    assert_respond_to @controller, :current_navigation
  end

  test 'defines methods like current_page' do
    assert_respond_to @controller, :current_page
  end
end
