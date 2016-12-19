require 'test_helper'

class Seiten::NavigationTest < ActiveSupport::TestCase
  test '.id' do
    nav = Seiten::Navigation.new(name: :site, locale: :en)
    assert_equal 'site.en', nav.id
  end

  test '#find_by' do
    assert_equal 'site.en', Seiten::Navigation.find_by(name: :site, locale: :en).id
    assert_equal 'site.de', Seiten::Navigation.find_by(name: 'site', locale: 'de').id
    assert_equal 'site.en', Seiten::Navigation.find_by(locale: :en).id
    assert_equal 'site.de', Seiten::Navigation.find_by(locale: 'de').id
  end
end
