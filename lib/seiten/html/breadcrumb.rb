module Seiten
  module HTML
    class Breadcrumb
      attr_reader :body

      def initialize(view_context, page:, separator: '>', html: {})
        @view_context = view_context
        @current_page = page
        @separator = separator
        @html_options = Seiten.config[:html].deep_merge(html || {})
        @body = build_navigation if @current_page
      end

      private

      def build_navigation
        classes = Seiten::HTML::Helpers.build_classes(class_options: @html_options[:breadcrumb], modifier_options: @html_options[:modifier])
        @view_context.content_tag(:ul, class: classes) do
          pages = @current_page.breadcrumbs.each_with_index.map do |page, index|
            build_page_element(page, index)
          end
          @view_context.safe_join(pages)
        end
      end

      def build_page_element(page, index)
        modifiers = page == @current_page ? [:current] : []
        classes   = Seiten::HTML::Helpers.build_classes(:item, modifiers: modifiers, class_options: @html_options[:breadcrumb], modifier_options: @html_options[:modifier])

        @view_context.content_tag :li, class: classes do
          if @separator && index.positive?
            sep_class = Seiten::HTML::Helpers.build_classes(:separator, class_options: @html_options[:breadcrumb])
            span = @view_context.content_tag(:span, @separator, class: sep_class)
          end
          link = @view_context.link_to_seiten_page(page)
          @view_context.safe_join([span, link])
        end
      end
    end
  end
end
