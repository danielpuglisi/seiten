class ActionDispatch::Routing::Mapper
  def seiten(*resources)
    options = resources.extract_options!
    options[:to] ||= 'seiten/pages#show'

    resources.each do |resource|
      resource_options = options.dup

      resource_options[:as] ||= resource == :application ? :seiten_page : "seiten_#{resource}_page"

      resource_options[:defaults] ||= {}
      resource_options[:defaults][:navigation_id] = resource unless resource == :application
      resource_options[:defaults][:slug] = ''

      get '(*slug)', resource_options
    end
  end
end
