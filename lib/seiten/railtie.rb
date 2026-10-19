module Seiten
  class Railtie < Rails::Railtie
    config.action_dispatch.rescue_responses.merge!(
      'Seiten::Errors::RoutingError' => :not_found
    )

    # Navigations built from I18n follow reloaded translations in development.
    config.to_prepare { Seiten.reset_i18n_navigations! }
  end
end
