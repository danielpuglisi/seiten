# Seiten

Seiten gives your Rails application a static navigation structure for your static and dynamic pages.

## Installation

Put the following line into your gem file:

    gem 'seiten'

## Setup routes

After you've run `bundle install`, add the following line to the bottom of your `config/routes.rb` to let your application pick up your seiten routes.

```ruby
# config/routes.rb

seiten # sets params[:navigation_id] to 'application' by default

# OR

seiten :help # sets params[:navigation_id] to 'help'

# OR combine multiple

scope :help do
  seiten :help
end
seiten :application
```

The above adds a catch all route to your routes. Make sure your other routes are defined before it, otherwise seiten will swallow them.

If you want to setup a seiten page as your applications root page do the following:

```ruby
# config/routes.rb
root :to => "seiten/pages#show"
```

## Setup navigation structure

Seiten needs two things to work:

* A YAML file where your navigation structure is stored
* and the page files you defined in your navigation structure

To setup the navigation structure create a `config/navigations` directory and add a `application.en.yml` file

```yml
# config/navigations/application.en.yml

- title: "Home"
  root: true
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

You can define the following attributes in the your navigation `yml` file:

* `title`: the title of the page
* `url` (optional): the url attribute defines the slug of your page.
Nested pages will automatically be prefixed with the url of their parent pages.  
  - If you define nothing, url automatically uses a `paramterize`'d version of the title.
  - Prefix the url with a `/` to use absolute paths.
  - Set url to `false` to add a navigational element without a slug.
* `refer` (optional): lets you link to another page  
  - Accepts an absolute or external path.
  - If set to `true`, links to first child of page.
* `nodes` (optional): lets you define the child pages of a page
* `layout` (optional):
  - Per default the `layout` attribute is passed on to its children pages.
  - If you only want to set the layout for a single page and not for its children set `inherit: false`
* `data` (optional):
  - Let's you add data to custom defined keys.
  - Must be a `Hash`.
  - The data can be accessed through symbols on the page object: `current_page.data[:description]`
* `html` (optional):
  - Let's you add custom html options to page navigations which will be picked up by the `seiten_navigation` helper.
  - You can use the same options as when you would use `content_tag`.
  - Must be a `Hash`.

Make sure to restart your Rails server after changing the configuration file.

## Setup navigations and pages

After defining the navigation structure make sure you have your static pages in place.

The Seiten helpers will look for the static pages in the `app/pages` directory.
So the pages need to be placed and ordered in the same hierarchy as defined in your navigation `yml` config.

Example:

```
- app/
  |
  |- en/
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

## I18n and multiple navigations

seiten enables you to define multiple navigations and/or locales per navigation:

```
- config/
  |
  |- navigations/
    |
    |- application.en.yml
    |- application.de.yml
    |- help.de.yml
    |- help.en.yml
```

During initialization, seiten will try to find static pages according to your navigation filenames within your `app/pages` directory:

```
- app/
  |
  |- pages/
    |
    |- application/
    | |
    | |- en/
    | | |
    | | |- contact.html.erb
    | | |- home.html.erb
    | | |- products.html.erb
    | | |
    | | |- about/
    | | | |- our-team.html.erb
    | | | |- partners.html.erb
    | | | |- works.html.erb
    | | |
    | | |- products/
    | |   |- hire-us.html.erb
    | |   |- logo-design.html.erb
    | |   |- web-development.html.erb
    | |
    | |- de/
    |   |
    |   |- kontakt.html.erb
    |   |- home.html.erb
    |   |- produkte.html.erb
    |   |
    |   |- uber-uns/
    |   | |- unser-team.html.erb
    |   | |- partner.html.erb
    |   | |- arbeiten.html.erb
    |   |
    |   |- produkte/
    |       |- heuere-uns-an.html.erb
    |       |- logo-design.html.erb
    |       |- web-development.html.erb
    |
    |- help/
      |
      |- en/
      | |
      | |- # your help.en.yml pages
      |
      |- de/
        |
        |- # your help.de.yml pages
```

### Caveats

seiten does not provide a way to link and switch between the same pages of different locales yet.

## Frontend helpers

### Navigation

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

### Breadcrumb

Seiten also has a breadcrumb helper:

```ruby
<%= seiten_breadcrumb %>
```

this gives you a breadcrumb navigation of the current page which is separated by a `>` per default.

You can change the link_separater in the following way:

```ruby
<%= seiten_breadcrumb link_separator: ">>" %>
```

### Modify CSS Classes

The CSS classes generated by the `seiten_navigation` and `seiten_breadcrumb` helpers can be modified for all navigations by modifing the `Seiten.config` hash:

```
# config/initializers/seiten.rb

html_options = Seiten.config[:html]
html_options[:navigation][:base] = 'navigation'
html_options[:navigation][:item] = 'navigation__item'
html_options[:navigation][:nodes] = 'navigation__nodes'
html_options[:breadcrumb][:base] = 'breadcrumb'
html_options[:breadcrumb][:item] = 'breadcrumb__item'
html_options[:breadcrumb][:separator] = 'breadcrumb__separator'
html_options[:modifier][:base] = nil # if nil we use the main class combined with the element class
html_options[:modifier][:separator] = '--' # modifier separator
html_options[:modifier][:parent] = 'parent'
html_options[:modifier][:active] = 'active'
html_options[:modifier][:current] = 'current'
html_options[:modifier][:expanded] = 'expanded'
```

or per navigation using the `html` parameter:

```
seiten_navigation(html: { navigation: { base: 'navbar-start' } })
```

## Backend helpers

seiten adds two convenience methods to your `ApplicationController`:

### `current_navigation`

`current_navigation` which returns the current `Seiten::Navigation` object.
seiten tries to automatically find a match using `params[:navigation_id]` and `params[:locale]` or `I18n.locale`.

### `current_page`

`current_page` which returns the current `Seiten::Page` object.
seiten tries to automatically find a match within the current_navigation using `params[:slug]`.

## Integration with your controllers

seiten works with your existing controllers but requires some minor adjustments.

By adding pages to your `config/navigations` config files which match your existing controller routes,
seiten will initially not be able to pick up the `current_navigation` as your routes do not define `params[:navigation_id]`.

There are two ways to solve this using your routes or controllers:

### Routes

```
scope defaults: { navigation_id: 'application', slug: '' } do
  resources :posts, defaults: { slug: 'blog' }
  # your other routes
end

seiten :application
```

### Controller

```
class PostsController < ApplicationController
  ...

  private

  def set_current_navigation
    Seiten::Navigation.find_by(navigation_id: 'application', locale: I18n.locale)
  end

  def set_current_page
    current_navigation.pages.find_by(slug: 'blog')
  end
end
```

## Todo

* Improve documentation
* Add rails generators (example config file, missing pages)
* Add a rake task which outputs missing pages in `app/pages`

## License

This project rocks and uses MIT-LICENSE.
