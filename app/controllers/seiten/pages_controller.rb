module Seiten
  class PagesController < ::ApplicationController
    prepend_view_path Seiten.config[:pages_dir]

    before_action :raise_routing_error, unless: :current_page

    def show
      render current_page.template_path, layout: current_page.layout
    end

    private

    def set_current_navigation
      Seiten::Navigation.find_by(name: params[:navigation_id].try(:to_sym) || :application, locale: params[:locale] || I18n.locale)
    end

    def set_current_page
      current_navigation.pages.find_by(slug: params[:page] || "") if current_navigation
    end

    def raise_routing_error
      raise ActionController::RoutingError.new("Page /#{params[:page]} not found")
    end
  end
end
