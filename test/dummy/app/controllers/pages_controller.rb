class PagesController < ApplicationController
  def secret
    @title = current_page
  end
end
