module Seiten
  class Railtie < Rails::Railtie
    config.action_dispatch.rescue_responses.merge!(
      'Seiten::Errors::RoutingError' => :not_found
    )
  end
end
