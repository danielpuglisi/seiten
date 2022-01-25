module Seiten
  module Helpers
    # Those helpers are convenience methods added to ApplicationController.
    module Current
      extend ActiveSupport::Concern

      included do
        if respond_to?(:helper_method)
          helper_method :current_navigation
          helper_method :current_page
        end
      end

      def current_navigation
        @current_navigation ||= set_current_navigation
      end

      def current_page
        @current_page ||= set_current_page
      end

      private

      def set_current_navigation
        Seiten::Navigation.find_by(name: params[:navigation_id] || 'application', locale: params[:locale] || I18n.locale.to_s)
      end

      def set_current_page
        current_navigation&.pages&.find_by(slug: params[:slug]) if params[:slug]
      end
    end
  end
end
