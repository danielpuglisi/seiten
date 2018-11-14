module SeitenHelper

  # TODO: Move logic into Seiten::Navigation class
  def seiten_navigation(*nav)
    options = nav.extract_options!

    navigation = nav.first || current_navigation

    output = ""

    parent_id = options[:parent_id] || nil
    deep      = options[:deep] || 2
    sub_level = options[:sub_level]
    @seiten_navigation_options ||= Seiten.config[:helpers][:navigation][:html].merge(options[:html] || {})

    if deep > 0
      content_tag(:ul, class: build_seiten_element_classes(sub_level ? :nodes : nil)) do
        navigation.pages.where(parent_id: parent_id).each do |page|
          children = seiten_navigation(navigation, parent_id: page.id, deep: deep-1, sub_level: true) if page.children.any?
          concat seiten_page_element(page, children)
        end
      end
    end
  end

  # TODO: Move logic into Seiten::Breadcrumb class
  def seiten_breadcrumb(options={})
    link_separator = options[:link_separator] || '>'

    if current_page
      output = content_tag(:ul, class: "breadcrumb") do
        Seiten::BreadcrumbBuilder.call(current_page).reverse.each_with_index.map do |page, index|
          content_tag :li, class: (page == current_page) ? 'active' : nil do
            concat content_tag(:span, link_separator) if link_separator && index > 0
            concat link_to_seiten_page(page)
          end
        end.join().html_safe
      end
      output
    end
  end

  private

  def link_to_seiten_page(page, options={})
    link_to page.title, url_for_seiten_page(page)
  end

  def url_for_seiten_page(page)
    return page.refer if page.refer
    return '#' if page.slug.nil?
    return page.slug if page.external?
    [:seiten, params[:navigation_id], :page, page: page.slug]
  end

  def seiten_page_element(page, children=nil)
    modifiers = build_seiten_page_modifiers(page)
    classes   = build_seiten_element_classes(:page, modifiers)
    content_tag(:li, class: classes) do
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

  def build_seiten_element_classes(element=nil, modifiers=[])
    class_options = @seiten_navigation_options[:class]
    classes = []

    klass = if element
              "#{class_options[:base]}#{class_options[:separators][:element]}#{class_options[:elements][element]}"
            else
              class_options[:base]
            end
    classes << klass

    if modifiers.any?
      base = (class_options[:mod_base].present? ? class_options[:mod_base] : klass)
      modifiers.each do |modifier|
        classes << "#{base}#{class_options[:separators][:modifier]}#{class_options[:modifiers][modifier]}"
      end
    end

    classes.join(' ')
  end
end
