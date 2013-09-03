module Seiten
  class PagesController < ::ApplicationController

    def show
      if current_page.nil?
        raise ActionController::RoutingError.new("Page /#{params[:page]} not found")
      else
        @title = current_page.title

        if params[:page]
          filename = params[:page]
        else
          filename = Seiten.config[:root_page_filename]
        end

        if File.exists? Seiten::PageStore.current.file_path(filename: "#{filename}.html.erb", locale: I18n.locale)
          file = Seiten::PageStore.current.file_path(filename: filename, locale: I18n.locale)
        else
          file = Seiten::PageStore.current.file_path(filename: filename)
        end

        if current_page.layout
          render file: file, layout: current_page.layout
        else
          render file: file
        end
      end
    end
  end
end
