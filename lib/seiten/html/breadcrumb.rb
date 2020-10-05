module Seiten
  module HTML
    class Breadcrumb
      attr_reader :body

      def initialize(view_context, page:, separator: '>')
        @view_context = view_context
        @page = page
        @separator = separator
        @body = build_navigation if @page
      end

      private

      def build_navigation
        @view_context.content_tag(:ul, class: 'breadcrumb') do
          pages = Seiten::BreadcrumbBuilder.call(@page).reverse.each_with_index.map do |page, index|
            @view_context.content_tag :li, class: page == @page ? 'active' : nil do
              span = @view_context.content_tag(:span, @separator) if @separator && index.positive?
              link = @view_context.link_to(page.title, page.path)
              @view_context.safe_join([span, link])
            end
          end
          @view_context.safe_join(pages)
        end
      end
    end
  end
end
