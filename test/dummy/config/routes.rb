Dummy::Application.routes.draw do
  root :to => "seiten/pages#show"

  get "/secret", to: "pages#secret"

  seiten_resources
end
