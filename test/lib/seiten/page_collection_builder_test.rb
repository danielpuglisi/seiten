require 'test_helper'

class Seiten::PageCollectionBuilderTest < ActiveSupport::TestCase

  def page_collection
    @page_collection ||= Seiten::PageCollection.new
  end

  def options
    @options ||= {
      pages: [
        {
          "title" => 'Home',
          "root" => true
        },
        {
          "title" => 'About us',
          "url" => false,
          "nodes" => [
            {
              "title" => "Team",
            },
            {
              "title" => "Contact us",
              "refer" => "/contact"
            },
            {
              "title" => "Parter",
              "refer" => "https://codegestalt.com"
            }
          ]
        },
        {
          "title" => "Projects",
          "refer" => true,
          "nodes" => [
            "title" => "Client work"
          ]
        }
      ]
    }
  end

  test 'should build a valid page collection' do
    assert_nothing_raised do
      Seiten::PageCollectionBuilder.call(page_collection, options)
    end

    assert_equal "Home", page_collection.find_by(slug: '').title
    assert_equal "Team", page_collection.find_by(slug: 'team').title
    assert_equal "Client work", page_collection.find_by(slug: 'projects/client-work').title
  end

  test 'should raise page refer exception' do
    options[:pages] << { "title" => 'Refer', "refer" => 'home' }
    err = assert_raises Seiten::PageError do
      Seiten::PageCollectionBuilder.call(page_collection, options)
    end
    assert_match "Refer must be true or an absolute or external path", err.message
  end
end
