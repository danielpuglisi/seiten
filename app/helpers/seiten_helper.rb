module SeitenHelper

  def render_html
    if params[:page]
      filename = params[:page]
    else
      filename = "home"
    end
    render :file => File.join(Rails.root, Seiten.config[:storage_directory], filename)
  end

  def seiten_navigation(parent_id=nil, deep=2)
    output ||= ""

    if deep > 0
      Seiten::Page.find_by_parent_id(parent_id).each do |page|
        status = page.active?(current_page) ? "active" : "inactive"
        output += "<li class='#{status}'>#{link_to(page.title, page.slug)}"
        unless page.children.blank?
          output += seiten_navigation(page.id, deep-1)
        end
        output += "</li>"
      end
    end
    raw "<ul>#{output}</ul>"
  end

  def seiten_breadcrumb
    output = content_tag(:ul, class: "breadcrumb") do
      Seiten::Page.get_breadcrumb(current_page).reverse.collect { |page|
        content_tag :li do
          raw "> #{link_to(page.title, page.slug)}"
        end
      }.join().html_safe
    end
    output
  end
end