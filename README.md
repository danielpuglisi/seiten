# Seiten

Seiten provides your Rails application with a static navigation structure for your static pages.

## Installation

Put the following line into your gem file:

    gem 'seiten'

After you've run 'bundle install', you're ready to go.

## Setup navigation structure

Seiten needs two things to work.

* A YAML file where your navigation structure is stored
* and the static pages files you define in that navigation structure

To setup the navigation structure create the following file in your `config` directory: `navigation.yml`

```yml
# config/navigation.yml

- title: "Home"
  url: "/"

- title: "Products"
  nodes:
    - title: "Logo Design"
    - title: "Web Development"
    - title: "Hire us"
      url: "/contact" # links to Contact page

- title: "About"
  redirect: true # redirects /about to /about/our-team
  nodes:
    - title: "Our Team"
    - title: "Works"
    - title: "Partners"
      nodes:
        - title: "Daniel Puglisi"
          url: "http://danielpuglisi.com"
        - title: "Codegestalt"
          url: "http://codegestalt.com"
        - title: "Kreatify"
          url: "http://kreatify.com"

- title: "Contact"
```

You can define the following attributes in the `navigation.yml` file:

* `title`: the title of the page (thank you mr. obvious)
* `url` (optional): the url attribute defines the slug of your page.
Nested pages will automatically be prefixed with the url of their parent page.  
  - If you define nothing, url automatically uses a `paramterize`'d version of the title.
  - Prefix the url with a `/` to use absolute paths if you for instance want to link to another page in the navigation structure.
  - Prefix links to external pages with `http://` or `https://`
* `redirect` (optional): If set to true, redirects to first child of page
* `nodes` (optional): lets you define the children pages of a page

## Setup static pages

After defining the navigation structure make sure you have your static pages in place.

The Seiten helpers will look for the static pages in the `app/pages` directory.
So the pages need to be placed and ordered in the same directory hirarchy as defined in `config/navigation.yml`.

Example:

```
- app/
  |
  |- pages/
    |
    |- about/
    |  |- our-team.html.erb
    |  |- partners.html.erb
    |  |- works.html.erb
    |
    |- contact.html.erb
    |- home.html.erb
    |- products.html.erb
    |
    |- products/
       |- hire-us.html.erb
       |- logo-design.html.erb
       |- web-development.html.erb
```

## Rendering navigations and accessing pages

To output your navigation structure as a `<ul>` list include the following helper into your layout:

```ruby
<%= seiten_navigation %>
```

Seiten also has a breadcrumb helper:

```ruby
<%= seiten_breadcrumb %>
```

this gives you a breadcrumb navigation of the current page.


## Todo

* Improve documentation
* Add rails generators (example config file, missing pages)
* Add a rake task which checks if every page in `navigation.yml` is in `app/pages`
* Provide more PageStore types: hash

This project rocks and uses MIT-LICENSE.
