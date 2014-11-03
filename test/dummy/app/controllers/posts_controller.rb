class PostsController < ApplicationController

  def index
  end

  private
    def set_current_page
      Seiten::Page.find_by_slug("blog")
    end
end
