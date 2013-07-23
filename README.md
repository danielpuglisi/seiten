# Seiten

Seiten provides your Rails application with a static navigation structure for your pages.

## Installation

Put the following line into your gem file:

    gem 'seiten'

After you've run 'bundle install' execute `rails seiten:install`.

## Helpers

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
* Add rails generators
* Add a rake task which checks if every page in `navigation.yml` is in `app/pages`
* Provide more PageStore types: hash

This project rocks and uses MIT-LICENSE.
