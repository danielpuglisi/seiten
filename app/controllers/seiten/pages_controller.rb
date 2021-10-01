module Seiten
  class PagesController < ::ApplicationController
    include Seiten::ControllerHelpers::Backend

    def show
      render_seiten_page
    end
  end
end
