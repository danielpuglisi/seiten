module Seiten
  module HTML
    class Navigation
      attr_reader :body

      def initialize(view_context, navigation:, parent_id: nil, current_page: nil, deep: 2, html: {})
        @view_context = view_context
        @start_depth = deep
        @html_options = Seiten.config[:html].deep_merge(html || {})
        @current_page = current_page
        @body = build_navigation(navigation, parent_id: parent_id, deep: deep)
      end

      private

      def build_navigation(navigation, parent_id:, deep:)
        wrapper_class = @start_depth != deep ? :nodes : nil

        return unless deep.positive?

        @view_context.content_tag(:ul, class: Seiten::HTML::Helpers.build_classes(wrapper_class, class_options: @html_options[:navigation], modifier_options: @html_options[:modifier])) do
          pages = navigation.pages.where(parent_id: parent_id).map do |page|
            children = build_navigation(navigation, parent_id: page.id, deep: deep - 1) if page.children?
            build_page_element(page, children)
          end
          @view_context.safe_join(pages)
        end
      end

      def build_page_element(page, children)
        modifiers = Seiten::HTML::Helpers.build_page_modifiers(page, @current_page)
        classes   = Seiten::HTML::Helpers.build_classes(:item, modifiers: modifiers, merge: page.html_options[:class], class_options: @html_options[:navigation], modifier_options: @html_options[:modifier])
        @view_context.content_tag(:li, page.html_options.merge(class: classes)) do
          @view_context.safe_join([@view_context.link_to_seiten_page(page), children])
        end
      end
    end
  end
end
