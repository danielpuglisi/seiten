module SeitenHelper

  def seiten_navigation(options={})
    output ||= ""
    parent_id = options[:parent_id] || nil
    deep      = options[:deep] || 2

    if deep > 0
      Seiten::Page.find_by_parent_id(parent_id).each do |page|
        status = page.active?(current_page) ? "active" : "inactive"
        output += "<li class='#{status}'>#{link_to(page.title, page.slug)}"
        unless page.children.blank?
          output += seiten_navigation(parent_id: page.id, deep: deep-1)
        end
        output += "</li>"
      end
      output = "<ul>#{output}</ul>"
    end
    raw output
  end

  def seiten_breadcrumb(options={})
    link_separator = options[:link_separator] || ">"

    if current_page
      output = content_tag(:ul, class: "breadcrumb") do
        Seiten::Page.get_breadcrumb(current_page).reverse.collect { |page|
          content_tag :li do
            raw "#{link_separator} #{link_to(page.title, page.slug)}"
          end
        }.join().html_safe
      end
      output
    end
  end
end
