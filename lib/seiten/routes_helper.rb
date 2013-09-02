class ActionDispatch::Routing::Mapper

  def seiten_resources
    Seiten::Page.all.each do |page|
      if page.redirect
        get page.slug, to: redirect { |p, req|
          Rails.application.routes.url_helpers.seiten_page_path(page: page.redirect, locale: p[:locale])
        }
      end
    end

    get "(*page)" => "seiten/pages#show", as: :seiten_page
  end
end
