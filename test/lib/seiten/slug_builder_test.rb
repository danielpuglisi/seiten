require 'test_helper'

class Seiten::SlugBuilderTest < ActiveSupport::TestCase

  test 'should return parameterized title' do
    slug = Seiten::SlugBuilder.call(title: 'My Page')
    assert_equal 'my-page', slug
  end

  test 'should return empty string' do
    slug = Seiten::SlugBuilder.call(title: 'Home', url: '/')
    assert_equal '', slug
    slug = Seiten::SlugBuilder.call(title: 'Home', root: true)
    assert_equal '', slug
  end

  test 'should remove leading slash' do
    slug = Seiten::SlugBuilder.call(title: 'Home', url: '/home')
    assert_equal 'home', slug
  end

  test 'should return external url' do
    slug = Seiten::SlugBuilder.call(title: 'Github', url: 'https://github.com')
    assert_equal 'https://github.com', slug
  end

  test 'should return absolute url' do
    slug = Seiten::SlugBuilder.call(
      {
        title: 'Contact',
        url: '/contact'
      },
      'about'
    )
    assert_equal 'contact', slug
  end

  test 'should return url with prefix' do
    slug = Seiten::SlugBuilder.call(
      {
        title: 'Projects'
      },
      'about'
    )
    assert_equal 'about/projects', slug
  end
end
