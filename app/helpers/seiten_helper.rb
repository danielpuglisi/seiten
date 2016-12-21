module SeitenHelper

  # TODO: Move logic into Seiten::PageLink class
  def link_to_seiten_page(title, slug, options={})
    if !!(slug.to_s.match(/^https?:\/\/.+/))
      link_to title, slug
    else
      link_to title, url_for(page: slug)
    end
  end

  # TODO: Move logic into Seiten::Navigation class
  def seiten_navigation(*nav)
    options = nav.extract_options!

    navigation = nav.first || current_navigation

    output  ||= ""
    parent_id = options[:parent_id] || nil
    deep      = options[:deep] || 2

    if deep > 0
      navigation.pages.where(parent_id: parent_id).each do |page|
        output += "<li class='#{seiten_navigation_page_class(page)}'>#{link_to_seiten_page(page.title, page.slug)}"
        unless page.children.blank?
          output += seiten_navigation(navigation, parent_id: page.id, deep: deep-1)
        end
        output += "</li>"
      end
      output = "<ul>#{output}</ul>"
    end
    raw output
  end

  # TODO: Move logic into Seiten::Breadcrumb class
  def seiten_breadcrumb(options={})
    link_separator = options[:link_separator] || '>'

    if current_page
      output = content_tag(:ul, class: "breadcrumb") do
        Seiten::BreadcrumbBuilder.call(current_page).reverse.each_with_index.map do |page, index|
          content_tag :li, class: (page == current_page) ? 'active' : nil do
            concat content_tag(:span, link_separator) if link_separator && index > 0
            concat link_to_seiten_page(page.title, page.slug)
          end
        end.join().html_safe
      end
      output
    end
  end

  def seiten_navigation_page_class(page)
    classes = ""
    if page.active?(current_page)
      classes << ' active'
      classes << (page == current_page ? ' current' : ' expanded')
    else
      classes << ' inactive'
    end
    classes.strip
  end
end
