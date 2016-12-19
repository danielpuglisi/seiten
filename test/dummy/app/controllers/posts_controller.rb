class PostsController < ApplicationController
  def index
  end

  private

  def set_current_page
    current_navigation.pages.find_by(slug: 'blog')
  end
end
