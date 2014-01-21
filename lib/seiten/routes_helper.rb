class ActionDispatch::Routing::Mapper

  def seiten_resources
    Seiten::PageStore.storages.each do |page_store|
      page_store.pages.each do |page|
        if page.redirect
          get page.slug, to: redirect { |p, req|
            Rails.application.routes.url_helpers.seiten_page_path(page: page.redirect, locale: p[:locale])
          }, as: nil
        end
      end
    end

    get "(*page)" => "seiten/pages#show", as: :seiten_page
  end
end
