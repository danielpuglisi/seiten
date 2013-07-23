module Seiten
  module Controllers
    # Those helpers are convenience methods added to ApplicationController.
    module Helpers
      extend ActiveSupport::Concern

      included do
        helper_method :current_page
      end

      def current_page
        @current_page ||= Seiten::Page.find_by_slug(request.fullpath)
      end
    end
  end
end
