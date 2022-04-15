Dummy::Application.routes.draw do
  get "/secret", to: "pages#secret"

  get "/blog",   to: "posts#index"

  scope :help do
    seiten :help
  end
  seiten :application
end
