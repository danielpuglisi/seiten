module Seiten
  class PagesController < ::ApplicationController

    def show
      if current_page.nil?
        raise ActionController::RoutingError.new("Page /#{params[:page]} not found")
      else
        if current_page.layout
          render file: current_page, layout: current_page.layout
        else
          render file: current_page
        end
      end
    end

    private
      def set_current_navigation
        Seiten::Navigation.find_by(name: params[:navigation_id].try(:to_sym) || :application, locale: params[:locale] || I18n.locale)
      end

      def set_current_page
        current_navigation.pages.find_by(slug: params[:page] || "") if current_navigation
      end
  end
end
