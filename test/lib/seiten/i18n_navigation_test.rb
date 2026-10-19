require 'test_helper'

class Seiten::I18nNavigationTest < ActiveSupport::TestCase
  def navigation(locale)
    Seiten::Navigation.find_by(name: 'guide', locale: locale)
  end

  def page(locale, key)
    navigation(locale).pages.find_by(key: key)
  end

  test 'one structure file gives a navigation in every available locale' do
    assert_equal ['de', 'en'], Seiten::Navigation.where(name: 'guide').map(&:locale).sort
  end

  test 'titles and slugs come from I18n, nested like the pages' do
    assert_equal 'Account verwalten', page('de', 'account.manage').title
    assert_equal 'dein-account/account-verwalten', page('de', 'account.manage').slug
    assert_equal 'your-account/account-security', page('en', 'account.security').slug, 'a translated slug replaces the title'
    assert_equal '', page('en', 'start').slug, 'url in the structure applies to every locale'
    assert_equal page('en', 'account'), page('en', 'account.manage').parent
  end

  test 'pages with the same key translate each other' do
    assert_equal page('en', 'account.manage'), page('de', 'account.manage').translation(:en)
    assert_equal({ 'de' => page('de', 'billing'), 'en' => page('en', 'billing') }, page('en', 'billing').translations)
  end

  test 'navigations are built again with reloaded translations' do
    I18n.backend.store_translations(:en, navigations: { guide: { billing: { title: 'Invoices' } } })
    Seiten.reset_i18n_navigations!

    assert_equal 'invoices', page('en', 'billing').slug
  ensure
    I18n.backend.store_translations(:en, navigations: { guide: { billing: { title: 'Billing' } } })
    Seiten.reset_i18n_navigations!
  end

  test 'a page needs a key and a title or slug' do
    assert_raises(Seiten::Errors::PageError) { Seiten.send(:i18n_pages, [{ 'title' => 'Untitled' }], :en, ['navigations', 'guide']) }
    assert_raises(Seiten::Errors::PageError) { Seiten.send(:i18n_pages, [{ 'key' => 'missing' }], :en, ['navigations', 'guide']) }
  end

  test 'navigations of one locale per file keep working' do
    assert_equal 'Produkte', Seiten::Navigation.find_by(name: 'application', locale: 'de').pages.find_by(slug: 'produkte').title
  end
end
