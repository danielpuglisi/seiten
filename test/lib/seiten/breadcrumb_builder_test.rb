require 'test_helper'

class Seiten::BreadcrumbBuilderTest < ActiveSupport::TestCase

  def navigation
    @navigation ||= Seiten::Navigation.find_by(id: 'application.en')
  end

  def page
    @page ||= navigation.pages.find_by(slug: 'about/our-team/switzerland')
  end

  test '::call' do
    assert_equal ['Switzerland', 'Our Team', 'About'], Seiten::BreadcrumbBuilder.call(page).map(&:title)
  end
end
