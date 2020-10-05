# frozen_string_literal: true

module SeitenHelper
  def seiten_navigation(navigation = current_navigation, parent_id: nil, deep: 2, html: {})
    Seiten::HTML::Navigation.new(self, navigation: navigation, parent_id: parent_id, current_page: current_page, deep: deep, html: html).body
  end

  # TODO: Move logic into Seiten::Breadcrumb class
  def seiten_breadcrumb(options = {})
    link_separator = options[:link_separator] || '>'

    return unless current_page

    output = content_tag(:ul, class: 'breadcrumb') do
      Seiten::BreadcrumbBuilder.call(current_page).reverse.each_with_index.map do |page, index|
        content_tag :li, class: page == current_page ? 'active' : nil do
          concat content_tag(:span, link_separator) if link_separator && index.positive?
          concat link_to_seiten_page(page)
        end
      end.join.html_safe
    end
    output
  end

  private

  def link_to_seiten_page(page)
    link_to page.title, page.path
  end
end
