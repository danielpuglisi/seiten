require 'test_helper'

class RedirectTest < ActionDispatch::IntegrationTest
  test 'should redirect to specificed page' do
    get '/products/hire-us'
    assert_redirected_to '/contact'
  end

  test 'should redirect to first child' do
    get '/about'
    assert_redirected_to '/about/our-team'
  end

  test 'should redirect to correct navigation path' do
    get '/help/features'
    assert_redirected_to '/help/features/adding-and-updating'
  end
end
