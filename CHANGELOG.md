# 1.2.0

One navigation file for every locale: `config/navigations/<name>.yml` (without a locale) builds the navigation in every `I18n.available_locales`, with titles and slugs from I18n under `navigations.<name>.<keys>` and the full key as each page's key.

The helpers test no longer adds pages to the application navigation, which made the navigation tests fail depending on the test order.

# 1.1.0

Link pages across locales: `Page#translation(locale)` and `Page#translations` find the same page in the navigations of the other locales, by position or by an optional `key`.

# 1.0.1

Suppress backtrace for `Seiten::Errors::RoutingError` to remove noise from log files
