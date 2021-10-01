module Seiten
  module ControllerHelpers
    # Those helpers are convenience methods added to Seiten::PagesController or useful for building your own.
    module Backend
      extend ActiveSupport::Concern

      def self.included(base)
        base.prepend_view_path Seiten.config[:pages_dir]
        base.before_action :raise_seiten_routing_error, unless: :current_page
      end

      private

      def set_current_navigation
        Seiten::Navigation.find_by(name: params[:navigation_id].try(:to_sym) || :application, locale: params[:locale] || I18n.locale)
      end

      def set_current_page
        current_navigation&.pages&.find_by(slug: params[:page] || '')
      end

      def raise_seiten_routing_error
        raise ActionController::RoutingError.new("Page /#{params[:page]} not found")
      end

      def render_seiten_page
        render current_page.template_path, layout: current_page.layout
      end
    end
  end
end
