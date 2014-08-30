module Seiten
  class PagesController < ::ApplicationController

    def show
      if current_page.nil?
        raise ActionController::RoutingError.new("Page /#{params[:page]} not found")
      else

        if params[:page]
          filename = params[:page]
        else
          filename = Seiten.config[:root_page_filename]
        end

        file = Seiten::PageStore.current.file_path(filename: filename)

        if current_page.layout
          render file: file, layout: current_page.layout
        else
          render file: file
        end
      end
    end
  end
end
