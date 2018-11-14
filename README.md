# Seiten

Seiten gives your Rails application a static navigation structure for your static and dynamic pages.

## Installation

Put the following line into your gem file:

    gem 'seiten'

After you've run `bundle install`, add the following line to your `config/routes.rb` to let your application pick up your pages.

```ruby
# config/routes.rb
seiten_resources
```

If you want to setup a static page as your applications root page do the following:

```ruby
# config/routes.rb
root :to => "seiten/pages#show"
```

and you're ready to go.

## Setup navigation structure

Seiten needs two things to work:

* A YAML file where your navigation structure is stored
* and the static pages files you define in that navigation structure

To setup the navigation structure create the following file in your `config` directory: `navigation.yml`

```yml
# config/navigation.yml

- title: "Home"
  url: "/"
  layout: "home"

- title: "Products"
  layout:
    name: "products"
    inherit: false
  nodes:
    - title: "Logo Design"
      data:
        header_image: "logo.jpg"
        description: "Fuck fiverr. We deliver the most beautiful shit you have ever seen and probably can't afford."
    - title: "Web Development"
      data:
        header_image: "web-development.jpg"
        description: "PHP? Get the hell out of here."
    - title: "Hire us"
      refer: "/contact" # refers to /contact

- title: "About"
  refer: true # refers to first child node (/about/our-team)
  nodes:
    - title: "Our Team"
    - title: "Works"
    - title: "Partners"
      nodes:
        - title: "Daniel Puglisi"
          refer: "http://danielpuglisi.com"
        - title: "Codegestalt"
          refer: "http://codegestalt.com"
        - title: "Kreatify"
          refer: "http://kreatify.com"

- title: "Contact"
```

You can define the following attributes in the `navigation.yml` file:

* `title`: the title of the page (thank you mr. obvious)
* `url` (optional): the url attribute defines the slug of your page.
Nested pages will automatically be prefixed with the url of their parent pages.  
  - If you define nothing, url automatically uses a `paramterize`'d version of the title.
  - Prefix the url with a `/` to use absolute paths.
  - Set url to `false` to add a navigational element without a slug.
* `refer` (optional): lets you link to another page  
  - Accepts an absolute or external path.
  - If set to `true`, links to first child of page.
* `nodes` (optional): lets you define the children pages of a page
* `layout` (optional):
  - Per default the `layout` attribute is passed on to its children pages.
  - If you only want to set the layout for a single page and not for its children set `inherit: false` (look in the example above)
* `data` (optional):
  - Let's you add data to custom defined keys.
  - Must be a `Hash`.
  - The data will be returned through symbols: `current_page.data[:description]`
* `html` (optional):
  - Let's you add custom html options to page navigations.
  - You can use the same options as when you would use `content_tag`.
  - Must be a `Hash`.

Make sure to restart your Rails server after changing the configuration file.

## Setup static pages

After defining the navigation structure make sure you have your static pages in place.

The Seiten helpers will look for the static pages in the `app/pages` directory.
So the pages need to be placed and ordered in the same hierarchy as defined in `config/navigation.yml`.

Example:

```
- app/
  |
  |- pages/
    |
    |- contact.html.erb
    |- home.html.erb
    |- products.html.erb
    |
    |- about/
    |  |- our-team.html.erb
    |  |- partners.html.erb
    |  |- works.html.erb
    |
    |- products/
       |- hire-us.html.erb
       |- logo-design.html.erb
       |- web-development.html.erb
```

## Helper methods

To output your navigation structure as a `<ul>` list include the following helper into your layout:

```ruby
<%= seiten_navigation %>
```

Per default the `seiten_navigation` method renders links which are nested two levels deep.
You can render more levels with the `deep` parameters:

```ruby
<%= seiten_navigation deep: 3 %>
```

If you want to output a subnavigation of a certain page, for example for the "Partner" page in our example,
you can do the following:

```ruby
<%= seiten_navigation parent_id: Seiten::Page.find_by_slug("about/partners") %>
```

Seiten also has a breadcrumb helper:

```ruby
<%= seiten_breadcrumb %>
```

this gives you a breadcrumb navigation of the current page which is separated by a `>` per default.

You can change the link_separater in the following way:

```ruby
<%= seiten_breadcrumb link_separator: ">>" %>
```

## I18n

### Configuration

Seiten allows you to create locale specific navigations and static page contents for your application.

Rename your `config/navigation.yml` file in the following way: `config/navigation/locale.yml`.  
For example: For the `:en` locale create a file called `config/navigation/en.yml` and for the `:de` locale create a file called `config/navigation/de.yml`.

If a localized navigation file is not found, seiten will look for `config/navigation.yml` per default.

### Static pages

If you want to create localized static content, use the following directory structure in your `app/pages` directory:

```
- app/
  |
  |- pages/
    |
    |- en/
    |  |
    |  |- contact.html.erb
    |  |- home.html.erb
    |  |- products.html.erb
    |  |
    |  |- about/
    |  |  |- our-team.html.erb
    |  |  |- partners.html.erb
    |  |  |- works.html.erb
    |  |
    |  |- products/
    |     |- hire-us.html.erb
    |     |- logo-design.html.erb
    |     |- web-development.html.erb
    |
    |- de/
       |
       |- kontakt.html.erb
       |- home.html.erb
       |- produkte.html.erb
       |
       |- uber-uns/
       |  |- unser-team.html.erb
       |  |- partner.html.erb
       |  |- arbeiten.html.erb
       |
       |- produkte/
          |- heuere-uns-an.html.erb
          |- logo-design.html.erb
          |- web-development.html.erb
```

### Switch Page Store

Per default, the navigation which matches the `config.i18n.default_locale` in `config/application.rb` will be set as the current page store on initialization.

To switch the current page store you can do the following:

```ruby
Seiten::PageStore.set_current_page_store(storage_language: :de)
```

for example in your `ApplicationController` you can do the following to switch your navigation when the locale changes:

```ruby
before_action :set_locale

...

private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    Seiten::PageStore.set_current_page_store(storage_language: I18n.locale)
  end
```

## Todo

* Improve documentation
* Add rails generators (example config file, missing pages)
* Add a rake task which outputs missing pages in `app/pages`
* Provide more PageStore possiblities (config format: hash, pages storage: dropbox, aws)

## License

This project rocks and uses MIT-LICENSE.
