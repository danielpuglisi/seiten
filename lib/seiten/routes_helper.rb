class ActionDispatch::Routing::Mapper
  # Routes a navigation's pages. Draw it after your other routes, which it would swallow.
  #
  # A navigation built in every locale from one file (config/navigations/help.yml) gets a route per
  # locale, under the locale and the navigation's slug (its I18n title or slug, see
  # Navigation#slug), to Help::PagesController#show, named help_page_<locale>:
  #
  #   seiten :help   # /en/help(/*slug), /de/hilfe(/*slug)
  #
  # Every page gets a link helper named after the navigation and its key, and the navigation one that
  # takes a key; both link to the page in I18n.locale or the `locale:` option:
  #
  #   help_account_manage_path                      # => "/en/help/your-account/manage-your-account"
  #   help_account_manage_url(locale: :de)          # => "http://…/de/hilfe/dein-account/account-verwalten"
  #   help_page_path(page.key)                      # the same, for a key in a variable; unknown keys raise
  #   help_page_path                                # => "/en/help", the navigation's root
  #
  # `to:`, `as:` (of the navigation's helper) and `path:` (the same in every locale) replace the
  # defaults, `prefix: false` names the page helpers without the navigation (account_manage_path), and
  # `localized: false` draws one catch-all route instead.
  #
  # Other navigations get one catch-all route to seiten/pages#show (or `to:`) that sets
  # params[:navigation_id] (except for the application navigation); `localized: true` routes them per
  # locale too.
  #
  #   seiten                         # /*slug, the application navigation
  #   scope(:help) { seiten :help }
  def seiten(*resources)
    options = resources.extract_options!
    localized, path, prefix = options.extract!(:localized, :path, :prefix).values_at(:localized, :path, :prefix)

    resources.each do |resource|
      name = resource.to_s

      if localized.nil? ? Seiten.i18n_navigation?(name) : localized
        seiten_localized_routes(name, options.dup, path: path, prefix: prefix.nil? ? name : prefix)
        next
      end

      resource_options = options.dup
      resource_options[:to] ||= 'seiten/pages#show'
      resource_options[:as] ||= resource == :application ? :seiten_page : "seiten_#{resource}_page"

      resource_options[:defaults] = resource_options[:defaults].to_h.dup
      resource_options[:defaults][:navigation_id] = name unless resource == :application
      resource_options[:defaults][:slug] = ''

      # NOTE: See https://github.com/rails/rails/issues/31228
      resource_options[:constraints] ||= ->(req) { req.path.exclude? 'rails/active_storage' }

      get '(*slug)', **resource_options
    end
  end

  private

  def seiten_localized_routes(name, options, path:, prefix:)
    navigations = Seiten::Navigation.where(name: name)
    raise ArgumentError, "No #{name} navigation in #{Seiten.config[:config_dir]}" if navigations.empty?

    route = (options.delete(:as) || "#{name}_page").to_s
    options = { to: "#{name}/pages#show", format: false, **options }
    defaults = { **options.delete(:defaults).to_h, navigation_id: name, slug: '' }

    navigations.each do |navigation|
      locale_path = [navigation.locale, path || navigation.slug].compact_blank.join('/')
      get "#{locale_path}(/*slug)", **options, as: "#{route}_#{navigation.locale}", defaults: defaults.merge(locale: navigation.locale)
    end

    keys = navigations.first.pages.all.filter_map(&:key)
    helpers = keys.map { |key| [prefix.presence, *key.split('.')].compact.join('_') }
    duplicate = [route, *helpers].tally.find { |_, count| count > 1 }&.first
    raise ArgumentError, "The #{name} navigation would define #{duplicate}_path twice" if duplicate

    seiten_link_helper(route, name, route)
    keys.zip(helpers).each { |key, helper| seiten_link_helper(helper, name, route, key) }
  end

  # <helper>_path and <helper>_url: the page with `page_key` (else the key given first, else the
  # navigation's root) in the navigation of I18n.locale or the `locale:` option.
  def seiten_link_helper(helper, navigation_name, route, page_key = nil)
    @set.add_url_helper(helper, {}) do |*args|
      options = args.extract_options!
      key = page_key || args.first
      locale = (options[:locale] || I18n.locale).to_s

      navigation = Seiten::Navigation.find_by(name: navigation_name, locale: locale)
      raise ArgumentError, "No #{navigation_name} navigation in #{locale}" unless navigation

      page = navigation.pages.find_by(key: key.to_s) if key
      raise ArgumentError, "No page #{key} in the #{navigation_name} navigation" if key && !page

      { use_route: "#{route}_#{locale}", slug: page&.slug.to_s, **options.except(:locale) }
    end
  end
end
