module Seiten
  class PagesController < ::ApplicationController

    def show
      if current_page.nil?
        # TODO: Move to before_action
        raise ActionController::RoutingError.new("Page /#{params[:page]} not found")
      else
        # TODO: Move to before_action
        if current_page.redirect
          redirect_to [:seiten, params[:navigation_id], :page, page: current_page.redirect]
          return
        end
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
