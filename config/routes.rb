Rails.application.routes.draw do

  # Redirects
  Seiten::Page.all.each do |page|
    if page.redirect
      get page.slug => redirect(page.children.first.slug)
    end
  end

  get "/*page" => "seiten/pages#show", as: :seiten_page
end
