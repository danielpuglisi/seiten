module PagesHelper

  def render_html
    if params[:page]
      filename = params[:page]
    else
      filename = "home"
    end
    render :file => "#{Rails.root}/app/pages/#{filename}"
  end
end
