class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :set_seo_values

  private

  def set_seo_values
    if current_page
      @title = current_page.metadata[:title] || current_page.title
    end
  end

  def set_current_navigation
    Seiten::Navigation.find_by(name: :application, locale: :en)
  end
end
