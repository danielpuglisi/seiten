require 'test_helper'

class SeitenHelperTest < ActionView::TestCase

  def navigation
    @navigation ||= Seiten::Navigation.find_by(id: 'application.en')
  end

  def current_navigation
    @current_navigation ||= navigation
  end

  def current_page
    @current_page ||= current_navigation.pages.find(1)
  end

  test '#seiten_navigation' do
    html = File.read(File.join(FIXTURES_DIR, 'navigation.html')).strip

    assert_equal html, seiten_navigation
  end

  test '#seiten_breadcrumb' do
    skip
  end
end
