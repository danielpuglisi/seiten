class ActionDispatch::Routing::Mapper

  def seiten_resources
    Seiten::Page.all.each do |page|
      if page.redirect
        get page.slug, to: redirect(page.redirect)
      end
    end
    get "(*page)" => "seiten/pages#show", as: :seiten_page
  end
end
