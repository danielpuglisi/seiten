# frozen_string_literal: true

module Seiten
  module Helpers
    module Frontend
      def link_to_seiten_page(page)
        link_to page.title, page.path
      end

      def seiten_navigation(navigation = current_navigation, parent_id: nil, deep: 2, html: {})
        Seiten::HTML::Navigation.new(self, navigation: navigation, parent_id: parent_id, current_page: current_page, deep: deep, html: html).body
      end

      def seiten_breadcrumb(separator: '>', html: {})
        Seiten::HTML::Breadcrumb.new(self, page: current_page, separator: separator, html: html).body
      end
    end
  end
end
