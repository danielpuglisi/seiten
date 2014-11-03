module Seiten
  module Controllers
    # Those helpers are convenience methods added to ApplicationController.
    module Helpers
      extend ActiveSupport::Concern

      included do
        helper_method :current_page
      end

      def current_page
        @current_page ||= defined?(set_current_page) ? set_current_page : nil
      end
    end
  end
end
