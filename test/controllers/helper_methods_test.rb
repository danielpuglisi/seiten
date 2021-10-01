require 'test_helper'

class CustomPagesController < ActionController::Base
  include Seiten::Helpers::Backend
end

class CurrentHelperMethodsTest < ActionController::TestCase
  tests CustomPagesController

  test 'includes Seiten::ControllerHelpers::Current' do
    assert_includes @controller.class.ancestors, Seiten::Helpers::Current
  end

  test 'includes Seiten::ControllerHelpers::Backend' do
    assert_includes @controller.class.ancestors, Seiten::Helpers::Backend
  end

  test 'defines methods like current_navigation' do
    assert_respond_to @controller, :current_navigation
  end

  test 'defines methods like current_page' do
    assert_respond_to @controller, :current_page
  end
end
