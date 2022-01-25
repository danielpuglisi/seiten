require 'test_helper'

class Seiten::ApplicationPagesControllerTest < ActionController::TestCase
  setup do
    @controller = Seiten::PagesController.new
  end

  def navigation
    @navigation ||= Seiten::Navigation.find_by(name: 'application', locale: 'en')
  end

  test 'should set current page when params[:slug] is empty' do
    get :show, params: { slug: '' }
    assert_equal(navigation, @controller.instance_eval { @current_navigation })
    assert_equal(navigation.pages.find_by(slug: ''), @controller.instance_eval { @current_page })
  end

  test 'should set products page as current page' do
    get :show, params: { slug: 'products' }
    assert_equal(navigation, @controller.instance_eval { @current_navigation })
    assert_equal(navigation.pages.find_by(slug: 'products'), @controller.instance_eval { @current_page })
  end
end

class Seiten::HelpPagesControllerTest < ActionController::TestCase
  setup do
    @controller = Seiten::PagesController.new
  end

  def navigation
    @navigation ||= Seiten::Navigation.find_by(name: 'help', locale: 'en')
  end

  test 'should set products page as current page' do
    get :show, params: { slug: 'logging-in', navigation_id: 'help' }
    assert_equal(navigation, @controller.instance_eval { @current_navigation })
    assert_equal(navigation.pages.find_by(slug: 'logging-in'), @controller.instance_eval { @current_page })
  end
end
