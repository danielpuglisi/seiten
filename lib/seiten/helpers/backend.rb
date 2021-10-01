module Seiten
  module Helpers
    # Those helpers are convenience methods added to Seiten::PagesController or useful for building your own.
    module Backend
      extend ActiveSupport::Concern

      def self.included(base)
        base.prepend_view_path Seiten.config[:pages_dir]
        base.before_action :raise_seiten_routing_error, unless: :current_page
      end

      private

      def raise_seiten_routing_error
        raise Seiten::Errors::RoutingError.new("Page /#{params[:slug]} not found")
      end

      def render_seiten_page
        render current_page.template_path, layout: current_page.layout
      end
    end
  end
end
