# 1.3.1

`PageCollection#find_by` no longer caches lookups that find nothing. Every unknown slug requested (a 404, a bot scanning for `/wp-admin`) added an entry that stayed until the process restarted.

# 1.3.0

Routes per locale: `seiten :help` routes a navigation built from one file (`config/navigations/help.yml`) under every locale and the navigation's slug (its I18n `title` or `slug`, e.g. `/de/hilfe(/*slug)`) to `Help::PagesController#show`, named `help_page_<locale>`. Every page gets a link helper named after the navigation and its key (`help_account_manage_path`), and `help_page_path(key)` links a page by a key in a variable (an unknown key raises); they link to the page in `I18n.locale` or the `locale:` option. `prefix: false` drops the navigation from the page helpers' names. `to:`, `as:` and `path:` replace the defaults, and `localized: false` keeps the single catch-all route these navigations got in 1.2. Navigations with one file per locale keep it too unless you pass `localized: true`.

`Navigation#title` and `#slug` come from I18n like a page's.

`seiten` no longer changes the `defaults:` hash it's given.

# 1.2.0

One navigation file for every locale: `config/navigations/<name>.yml` (without a locale) builds the navigation in every `I18n.available_locales`, with titles and slugs from I18n under `navigations.<name>.<keys>` and the full key as each page's key.

The helpers test no longer adds pages to the application navigation, which made the navigation tests fail depending on the test order.

# 1.1.0

Link pages across locales: `Page#translation(locale)` and `Page#translations` find the same page in the navigations of the other locales, by position or by an optional `key`.

# 1.0.1

Suppress backtrace for `Seiten::Errors::RoutingError` to remove noise from log files
