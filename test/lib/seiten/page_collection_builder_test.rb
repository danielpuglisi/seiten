require 'test_helper'

class Seiten::PageCollectionBuilderTest < ActiveSupport::TestCase

  def page_collection
    @page_collection ||= Seiten::PageCollection.new
  end

  def options
    @options ||= Hash[:pages, []]
  end

  test 'should build root page' do
    options[:pages] << { "title" => "Home", "root" => true }
    Seiten::PageCollectionBuilder.call(page_collection, options)

    assert_equal "Home", page_collection.find_by(slug: '').title
  end

  test 'should build page with a defined url' do
    options[:pages] << { "title" => "About us", "url" => 'about' }
    Seiten::PageCollectionBuilder.call(page_collection, options)

    assert_equal "About us", page_collection.find_by(slug: 'about').title
  end

  test 'should build a child page with a defined url' do
    options[:pages] << { "title" => "About us", "nodes" => [{ "title" => "Team", "url" => "/team" }] }
    Seiten::PageCollectionBuilder.call(page_collection, options)

    assert_equal "Team", page_collection.find_by(slug: 'team').title
  end

  test 'should build page without an url' do
    options[:pages] << { "title" => "About us", "url" => false }
    Seiten::PageCollectionBuilder.call(page_collection, options)

    assert_equal "About us", page_collection.where(slug: nil).first.title
  end

  test 'should build child page' do
    options[:pages] << { "title" => "About us", "nodes" => [{ "title" => "Team" }] }
    Seiten::PageCollectionBuilder.call(page_collection, options)

    assert_equal "About us", page_collection.find_by(slug: 'about-us').title
    assert_equal "Team", page_collection.find_by(slug: 'about-us/team').title
  end

  test 'should build child page of child page' do
    options[:pages] << { "title" => "About us", "nodes" => [{ "title" => "Team", "nodes" => [{ "title" => "Management" }] }] }
    Seiten::PageCollectionBuilder.call(page_collection, options)

    parent = page_collection.find_by(slug: 'about-us')
    child_1 = page_collection.find_by(slug: 'about-us/team')
    child_2 = page_collection.find_by(slug: 'about-us/team/management')

    assert_equal "About us", parent.title
    assert_equal "Team", child_1.title
    assert_equal "Management", child_2.title

    assert_nil parent.parent_id
    assert_equal parent.id, child_1.parent_id
    assert_equal child_1.id, child_2.parent_id
  end

  test 'should build child page without parent url' do
    options[:pages] << { "title" => "About us", "url" => false, "nodes" => [{ "title" => "Team" }] }
    Seiten::PageCollectionBuilder.call(page_collection, options)

    assert_equal "About us", page_collection.where(slug: nil).first.title
    assert_equal "Team", page_collection.find_by(slug: 'team').title
  end

  test 'should build a page that refers to its first child' do
    options[:pages] << { "title" => "About us", "refer" => true, "nodes" => [{ "title" => "Team" }] }
    Seiten::PageCollectionBuilder.call(page_collection, options)

    assert_equal "/team", page_collection.where(slug: nil).first.refer
  end

  test 'should build a referer page with an absolute path' do
    options[:pages] << { "title" => "About us", "refer" => "/team" }
    Seiten::PageCollectionBuilder.call(page_collection, options)

    assert_equal "/team", page_collection.where(slug: nil).first.refer
  end

  test 'should build a referer page with an external path' do
    options[:pages] << { "title" => "About us", "refer" => "https://codegestalt.com" }
    Seiten::PageCollectionBuilder.call(page_collection, options)

    assert_equal "https://codegestalt.com", page_collection.where(slug: nil).first.refer
  end

  test 'should build a page with a layout' do
    options[:pages] << { "title" => "About us", "layout" => "team", "nodes" => [{ "title" => "Team" }] }
    Seiten::PageCollectionBuilder.call(page_collection, options)

    assert_equal "team", page_collection.find_by(slug: 'about-us').layout
    assert_equal "team", page_collection.find_by(slug: 'about-us/team').layout
  end

  test 'should build a page with an inherited layout' do
    options[:pages] << { "title" => "About us", "layout" => { "name" => "team", "inherit" => true }, "nodes" => [{ "title" => "Team" }] }
    Seiten::PageCollectionBuilder.call(page_collection, options)

    assert_equal "team", page_collection.find_by(slug: 'about-us').layout
    assert_equal "team", page_collection.find_by(slug: 'about-us/team').layout
  end

  test 'should build a page without inheriting the layout' do
    options[:pages] << { "title" => "About us", "layout" => { "name" => "team", "inherit" => false }, "nodes" => [{ "title" => "Team" }] }
    Seiten::PageCollectionBuilder.call(page_collection, options)

    assert_equal "team", page_collection.find_by(slug: 'about-us').layout
    assert_nil page_collection.find_by(slug: 'about-us/team').layout
  end

  test 'should raise page refer exception' do
    options[:pages] << { "title" => 'Refer', "refer" => 'home' }
    err = assert_raises Seiten::PageError do
      Seiten::PageCollectionBuilder.call(page_collection, options)
    end
    assert_match "The `refer` option must be `true` or an absolute or external path", err.message
  end

  test 'should raise page url exception' do
    options[:pages] << { "title" => 'External path', "url" => 'https://codegestalt.com' }
    err = assert_raises Seiten::PageError do
      Seiten::PageCollectionBuilder.call(page_collection, options)
    end
    assert_match "The `url` option can not be an external path. Use the `refer` option to link to external resources.", err.message
  end
end
