require 'test_helper'

class Seiten::HTML::NavigationTest < ActiveSupport::TestCase
  def context
    controller = ApplicationController.new
    controller.view_context.tap do |context|
      context.instance_eval do
        def url_options
          { host: 'localhost:3000' }
        end
      end
    end
  end

  def navigation
    @navigation ||= Seiten::Navigation.find_by(id: 'application.en')
  end

  def current_page
    @current_page ||= navigation.pages.find_by(slug: '')
  end

  test '::new' do
    nav = Seiten::HTML::Navigation.new(context, navigation: navigation, current_page: current_page)
    html = File.read(File.join(FIXTURES_DIR, 'navigation.html')).strip

    assert_equal html, nav.body
  end
end
