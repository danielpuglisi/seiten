require 'test_helper'

class Seiten::PageTest < ActiveSupport::TestCase

  def navigation
    @navigation ||= Seiten::Navigation.new(name: :test, locale: :en)
  end

  def pages
    @pages ||= navigation.pages
  end

  setup do
    Seiten.navigations << navigation
  end

  teardown do
    Seiten.navigations = Seiten.navigations - [navigation]
    navigation.pages = []
  end

  test '#navigation' do
    page = pages.new

    assert_equal navigation, page.navigation
  end

  test '#external?' do
    page = pages.new

    page.slug = 'about-us'
    assert_not page.external?

    page.slug = 'http://codegestalt.com'
    assert page.external?
  end

  test '#parent' do
    parent_page = pages.new(id: 5)
    child_page  = pages.new(id: 10, parent_id: 5)

    assert_equal parent_page, child_page.parent
    assert_nil parent_page.parent
  end

  test '#parent?' do
    parent_page = pages.new(id: 5)
    child_page  = pages.new(id: 10, parent_id: 5)

    assert child_page.parent?
    child_page.parent_id = nil
    assert_not parent_page.parent?
    child_page.parent_id = 4
    assert_not child_page.parent?
  end

  test '#ancestors' do
    parent_page  = pages.new(id: 5)
    child_page_1 = pages.new(id: 10, parent_id: 5)
    child_page_2 = pages.new(id: 15, parent_id: 10)

    assert_equal [], parent_page.ancestors
    assert_equal [parent_page], child_page_1.ancestors
    assert_equal [child_page_1, parent_page], child_page_2.ancestors
  end

  test '#self_and_ancestors' do
    parent_page  = pages.new(id: 5)
    child_page_1 = pages.new(id: 10, parent_id: 5)
    child_page_2 = pages.new(id: 15, parent_id: 10)

    assert_equal [parent_page], parent_page.self_and_ancestors
    assert_equal [child_page_1, parent_page], child_page_1.self_and_ancestors
    assert_equal [child_page_2, child_page_1, parent_page], child_page_2.self_and_ancestors
  end

  test '#root' do
    parent_page  = pages.new(id: 5)
    child_page_1 = pages.new(id: 10, parent_id: 5)
    child_page_2 = pages.new(id: 15, parent_id: 10)

    assert_equal parent_page, child_page_2.root
    assert_equal parent_page, child_page_1.root
    assert_equal parent_page, parent_page.root
  end

  test '#children' do
    parent_page  = pages.new(id: 5)
    child_page_1 = pages.new(id: 10, parent_id: 5)
    child_page_2 = pages.new(id: 15, parent_id: 5)
    child_page_3 = pages.new(id: 20, parent_id: 5)

    assert_equal [child_page_1, child_page_2, child_page_3], parent_page.children
  end

  test '#children?' do
    parent_page  = pages.new(id: 5)
    child_page_1 = pages.new(id: 10, parent_id: 5)

    assert_equal true, parent_page.children?
    assert_equal false, child_page_1.children?
  end

  test '#parent_of?' do
    parent_page  = pages.new(id: 5)
    child_page_1 = pages.new(id: 10, parent_id: 5)
    child_page_2 = pages.new(id: 15, parent_id: 10)
    sibling_page = pages.new(id: 25)

    assert parent_page.parent_of?(child_page_1)
    assert parent_page.parent_of?(child_page_2)
    assert child_page_1.parent_of?(child_page_2)

    assert_not child_page_1.parent_of?(parent_page)
    assert_not child_page_2.parent_of?(parent_page)

    assert_not sibling_page.parent_of?(parent_page)
    assert_not parent_page.parent_of?(sibling_page)
  end

  test '#active?' do
    parent_page  = pages.new(id: 5)
    child_page   = pages.new(id: 10, parent_id: 5)
    sibling_page = pages.new(id: 15)

    assert parent_page.active?(parent_page)
    assert parent_page.active?(child_page)
    assert_not parent_page.active?(sibling_page)

    assert child_page.active?(child_page)
    assert_not child_page.active?(parent_page)
    assert_not child_page.active?(sibling_page)

    assert_nil parent_page.active?(nil)
  end

  test '#template_path' do
    page = pages.new(slug: 'about-us/projects')

    assert_equal 'test/en/about-us/projects', page.template_path

    page = pages.new(slug: '')

    assert_equal 'test/en/home', page.template_path
  end

  test '#data' do
    page = pages.new
    assert_equal Hash.new, page.data
    assert_nil page.data[:header_image]

    page = pages.new(data: { header_image: 'logo.jpg', description: 'Our logo design is awesome.' })
    assert_equal({ header_image: 'logo.jpg', description: 'Our logo design is awesome.' }, page.data)
    assert_equal "logo.jpg", page.data[:header_image]
  end

  test '#path' do
    # Regular page
    page = pages.new(slug: 'about/products')
    assert_equal [:seiten, :test, :page, { slug: 'about/products' }], page.path

    # Regular page
    navigation.name = 'application'
    navigation.pages.navigation_id = "application.en"
    page = pages.new(slug: 'about/products')
    assert_equal [:seiten, nil, :page, { slug: 'about/products' }], page.path

    # External page
    page = pages.new(slug: 'https://codegestalt.com')
    assert_equal 'https://codegestalt.com', page.path

    # Anchor page
    page = pages.new(slug: nil)
    assert_equal '#', page.path

    # Refer page
    page = pages.new(refer: '/about/our-team')
    assert_equal '/about/our-team', page.path
  end

  test '#layout' do
    page = pages.new
    assert_equal 'application', page.layout

    page = pages.new(layout: 'custom')
    assert_equal 'custom', page.layout
  end
end
