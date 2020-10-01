# frozen_string_literal: true

module SeitenHelper
  # TODO: Move logic into Seiten::Navigation class
  def seiten_navigation(*nav)
    options = nav.extract_options!

    navigation = nav.first || current_navigation

    parent_id = options[:parent_id] || nil
    deep      = options[:deep] || 2
    sub_level = options[:sub_level]
    html_options = Seiten.config[:helpers][:navigation][:html].deep_merge(options[:html] || {})

    return unless deep.positive?

    content_tag(:ul, class: build_seiten_element_classes(sub_level ? :nodes : nil, class_options: html_options[:class])) do
      navigation.pages.where(parent_id: parent_id).each do |page|
        children = seiten_navigation(navigation, parent_id: page.id, deep: deep - 1, sub_level: true, html: html_options) if page.children.any?
        concat seiten_page_element(page, children, html_options)
      end
    end
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
    link_to page.title, url_for_seiten_page(page)
  end

  def url_for_seiten_page(page)
    return page.refer if page.refer
    return '#' if page.slug.nil?
    return page.slug if page.external?

    [:seiten, params[:navigation_id], :page, { page: page.slug }]
  end

  def seiten_page_element(page, children, html_options)
    modifiers = build_seiten_page_modifiers(page)
    classes   = build_seiten_element_classes(:item, modifiers: modifiers, merge: page.html_options[:class], class_options: html_options[:class])
    content_tag(:li, page.html_options.merge(class: classes)) do
      concat link_to_seiten_page(page)
      concat children
    end
  end

  def build_seiten_page_modifiers(page)
    modifiers = []
    modifiers << :parent if page.children.present?
    if page.active?(current_page)
      modifiers << :active
      modifiers << (page == current_page ? :current : :expanded)
    end
    modifiers
  end

  def build_seiten_element_classes(element = nil, class_options:, modifiers: [], merge: nil)
    classes = []

    klass = class_options[element || :base]
    classes << klass

    if modifiers.any?
      base = (class_options[:mod_base].presence || klass)
      modifiers.each do |modifier|
        classes << "#{base}#{class_options[:mod_sep]}#{class_options[:modifiers][modifier]}"
      end
    end

    classes << merge if merge
    classes.join(' ')
  end
end
