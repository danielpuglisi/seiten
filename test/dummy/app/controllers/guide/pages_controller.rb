class Guide::PagesController < ApplicationController
  def show
    render plain: "#{current_navigation.id} #{current_page&.key}"
  end
end
