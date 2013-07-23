module Seiten
  class PagesController < ::ApplicationController

    def show
      if current_page.nil?
        head :not_found
      else
        @title = current_page.title
      end
    end
  end
end
