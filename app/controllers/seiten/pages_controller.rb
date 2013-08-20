module Seiten
  class PagesController < ::ApplicationController

    def show
      if current_page.nil?
        head :not_found
      else
        @title = current_page.title
        render layout: current_page.layout if current_page.layout 
      end
    end
  end
end
