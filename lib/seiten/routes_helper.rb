class ActionDispatch::Routing::Mapper

  def seiten_resource(*resource)
    options = resource.extract_options!.dup

    navigations = Seiten::Navigation.where(name: resource.first||:application)
    navigations.each do |navigation|
      navigation.pages.all.each do |page|
        if page.redirect
          get page.slug, to: redirect { |p, req|
            Rails.application.routes.url_helpers.seiten_page_path(page: page.redirect, locale: p[:locale])
          }, as: nil
        end
      end
    end

    get "(*page)", to: "seiten/pages#show", as: :seiten_page
  end
end
