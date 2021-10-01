module Seiten
  class PagesController < ::ApplicationController
    include Seiten::Helpers::Backend

    def show
      render_seiten_page
    end
  end
end
