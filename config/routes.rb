Rails.application.routes.draw do

  # Redirects
  Seiten::Page.all.each do |page|
    if page.redirect
      get page.slug => redirect(page.redirect)
    end
  end

  get "/*page" => "seiten/pages#show", as: :seiten_page
end
