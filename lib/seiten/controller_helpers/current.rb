module Seiten
  module ControllerHelpers
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
        @current_navigation ||= defined?(set_current_navigation) ? set_current_navigation : nil
      end

      def current_page
        @current_page ||= defined?(set_current_page) ? set_current_page : nil
      end
    end
  end
end
