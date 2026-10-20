Dummy::Application.routes.draw do
  get "/secret", to: "pages#secret"

  get "/blog",   to: "posts#index"

  seiten :guide

  scope :help do
    seiten :help
  end
  seiten :application
end
