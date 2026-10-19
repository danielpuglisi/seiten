require 'test_helper'

class Seiten::PageTranslationTest < ActiveSupport::TestCase
  def build(locale, pages)
    navigation = Seiten::Navigation.new(name: :manual, locale: locale)
    Seiten.navigations << navigation
    navigation.pages.build(pages: pages)
    navigation
  end

  def page(navigation, title)
    navigation.pages.find_by(title: title)
  end

  setup do
    @de = build(:de, [
      { 'title' => 'Einleitung', 'nodes' => [{ 'title' => 'Module' }, { 'title' => 'Account einrichten' }] },
      { 'title' => 'Rechnungen', 'key' => 'invoices' },
      { 'title' => 'Kontakt' }
    ])
    @en = build(:en, [
      { 'title' => 'Introduction', 'nodes' => [{ 'title' => 'Modules' }, { 'title' => 'Set up your account' }] },
      { 'title' => 'Pricing' },
      { 'title' => 'Contact' },
      { 'title' => 'Invoices', 'key' => 'invoices' }
    ])
  end

  teardown do
    Seiten.navigations -= [@de, @en]
  end

  test '#position is the index path in the navigation tree' do
    assert_equal [0], page(@de, 'Einleitung').position
    assert_equal [0, 1], page(@de, 'Account einrichten').position
    assert_equal [2], page(@de, 'Kontakt').position
  end

  test '#translation finds the page at the same position in the other locale' do
    assert_equal page(@en, 'Introduction'), page(@de, 'Einleitung').translation(:en)
    assert_equal page(@en, 'Set up your account'), page(@de, 'Account einrichten').translation('en')
    assert_equal page(@de, 'Module'), page(@en, 'Modules').translation(:de)
    assert_equal page(@en, 'Contact'), page(@de, 'Kontakt').translation(:en)
  end

  test '#translation matches pages with a key by their key, wherever they are' do
    assert_equal page(@en, 'Invoices'), page(@de, 'Rechnungen').translation(:en)
    assert_equal page(@de, 'Rechnungen'), page(@en, 'Invoices').translation(:de)
  end

  test '#translation leaves out pages without a counterpart' do
    assert_nil page(@en, 'Pricing').translation(:de), 'the German page at its position has a key'
    assert_nil page(@de, 'Einleitung').translation(:fr), 'no French navigation'
  end

  test '#translation of the own locale is the page itself' do
    assert_equal page(@de, 'Module'), page(@de, 'Module').translation(:de)
  end

  test '#translations lists the page in every locale that has it' do
    assert_equal({ 'de' => page(@de, 'Module'), 'en' => page(@en, 'Modules') }, page(@de, 'Module').translations)
    assert_equal({ 'en' => page(@en, 'Pricing') }, page(@en, 'Pricing').translations)
  end
end
