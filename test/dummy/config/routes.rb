Dummy::Application.routes.draw do
  root :to => "seiten/pages#show"

  get "/secret", to: "pages#secret"

  get "/blog",   to: "posts#index"

  seiten_resources
end
