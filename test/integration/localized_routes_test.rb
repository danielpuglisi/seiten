require 'test_helper'

class Seiten::LocalizedRoutesTest < ActionDispatch::IntegrationTest
  def route_set(&)
    ActionDispatch::Routing::RouteSet.new.tap do |routes|
      routes.default_url_options[:host] = 'example.com'
      routes.draw(&)
    end
  end

  def draw(&)
    route_set(&).routes.map { |route| [route.name, route.path.spec.to_s, route.defaults.except(:action, :slug)] }
  end

  test 'routes a navigation of one file under each locale and its slug, to its pages controller' do
    get '/de/anleitung/dein-account/account-verwalten'
    assert_equal 'guide.de account.manage', response.body

    get '/en/guide'
    assert_equal 'guide.en start', response.body
  end

  test 'names the routes after the navigation and the locale' do
    assert_equal '/de/anleitung/rechnungen', guide_page_de_path(slug: 'rechnungen')
  end

  test 'to, as and path replace the defaults' do
    assert_equal [['docs_de', '/de/doku(/*slug)', { controller: 'docs', navigation_id: 'guide', locale: 'de' }],
                  ['docs_en', '/en/doku(/*slug)', { controller: 'docs', navigation_id: 'guide', locale: 'en' }]],
                 draw { seiten :guide, to: 'docs#show', as: :docs, path: 'doku' }.sort
  end

  test 'localized: false draws one catch-all route' do
    assert_equal [['seiten_guide_page', '/(*slug)(.:format)', { controller: 'seiten/pages', navigation_id: 'guide' }]],
                 draw { seiten :guide, localized: false }
  end

  test 'navigations of one file per locale get one catch-all route unless localized' do
    assert_equal 1, draw { seiten :application }.size
    assert_equal ['/de(/*slug)', '/en(/*slug)'], draw { seiten :application, localized: true }.map(&:second).sort
  end

  test 'links a page by its key in the current or the given locale' do
    I18n.with_locale(:de) { assert_equal '/de/anleitung/dein-account/account-verwalten', guide_page_path('account.manage') }
    assert_equal '/en/guide/your-account/account-security', guide_page_path('account.security', locale: :en)
    assert_equal 'http://example.com/de/anleitung/rechnungen?page=2#top', guide_page_url('billing', locale: 'de', host: 'example.com', page: 2, anchor: 'top')
  end

  test 'links the navigation root without a key' do
    assert_equal '/en/guide', guide_page_path
    assert_equal '/de/anleitung', guide_page_path(locale: :de)
  end

  test 'page helpers are named after the navigation and the key' do
    assert_equal '/en/guide/your-account/manage-your-account', guide_account_manage_path
    assert_equal 'http://example.com/de/anleitung/rechnungen#top', guide_billing_url(locale: :de, host: 'example.com', anchor: 'top')
    assert_equal '/en/guide', guide_start_path
  end

  test 'prefix: false names the page helpers after the key only' do
    helpers = route_set { seiten :guide, prefix: false }.url_helpers

    assert_equal '/en/guide/your-account/manage-your-account', helpers.account_manage_path
    assert_respond_to helpers, :guide_page_path
  end

  test 'raises for an unknown page or locale' do
    assert_raises(ArgumentError) { guide_page_path('account.missing') }
    assert_raises(ArgumentError) { guide_page_path('billing', locale: :fr) }
  end
end
