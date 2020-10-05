require 'test_helper'

class SeitenHelperTest < ActionView::TestCase

  def navigation
    @navigation ||= Seiten::Navigation.find_by(id: 'application.en')
  end

  def current_navigation
    @current_navigation ||= navigation
  end

  def current_page
    @current_page
  end

  test '#seiten_navigation' do
    @current_page = current_navigation.pages.find(1)
    html = File.read(File.join(FIXTURES_DIR, 'navigation.html')).strip

    assert_equal html, seiten_navigation
  end

  test '#seiten_breadcrumb' do
    @current_page = current_navigation.pages.find_by(slug: 'about/our-team/switzerland')
    html = File.read(File.join(FIXTURES_DIR, 'breadcrumb.html')).strip

    assert_equal html, seiten_breadcrumb
  end
end
