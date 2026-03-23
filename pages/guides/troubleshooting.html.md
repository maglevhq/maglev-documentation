---
title: Troubleshooting
order: 12
---

# Troubleshooting

{% hint style="info" %}
Search your error message in [maglev-core issues](https://github.com/maglevhq/maglev-core/issues) before digging deeper.
{% endhint %}

## Editor returns 401 / “not authorized”

Maglev does not ship its own user database. Confirm `config.is_authenticated` in `config/initializers/maglev.rb` matches how your app decides who may edit, and that `ApplicationController` rescues `Maglev::Errors::NotAuthorized` if you redirect or flash a message. See [Secure the editor](/guides/setup-authentication).

## Public pages show draft or old content

Maglev serves **published** content to visitors. After upgrading or bulk edits, run a publish task if your version provides one (for example `bundle exec rails maglev:publish_site`) and confirm editors clicked **Publish** for the page. See [Concepts overview — Draft and published pages](/concepts/overview).

## Sections or assets look wrong only in the editor

The editor loads Stimulus and importmap-driven JS from the engine. Check the browser console for 404s on script tags, and verify you did not block Maglev routes or CSP rules for inline or module scripts on editor paths.

## Theme layout or `render_maglev_sections` errors

Ensure `app/views/theme/layout.html.erb` still calls `render_maglev_sections` with the expected locals (`site`, `theme`, `page`, `page_sections`, etc.) as in a fresh install. A missing `<main data-maglev-dropzone>` (or equivalent) can break drop targeting in the UI.

## Collections picker is empty or images break

Collection **`image`** methods must return a **stable public URL**. Active Storage blobs without a CDN or proxy often fail in the picker. See [Setup collections](/guides/setup-collections).

## Maglev **editor** UI CSS (Tailwind) and **`sassc`**

The Maglev **visual editor** ships with styles built from **Tailwind CSS**. That bundle is **Tailwind-generated output** meant to be served as ordinary CSS. In host apps that still use **`sassc-rails`**, **Sprockets** can try to run **all** stylesheets—including styles mounted from the **Maglev engine**—through **libsass** (`sassc`). That second pass is **not compatible** with the editor’s Tailwind-generated CSS and often shows up as **Sass compile errors** during `rails assets:precompile` (or when assets compile in development).

**What to do:** ensure the **editor** styles are **not** processed by **`sassc` / `sassc-rails`**. In practice that usually means **removing `sassc-rails`** from the app and moving anything you still author in Sass to [**`dartsass-rails`**](https://github.com/rails/dartsass-rails) (Dart Sass), or adopting the **Rails 7+** asset setup where engine CSS is linked without a libsass step. After updating the `Gemfile`, run `bundle install` and rebuild assets.

This note is about the **editor UI** only; your **theme** / section CSS (for example Tailwind for the public site) follows your own pipeline (`tailwindcss-rails`, `cssbundling-rails`, etc.) and is separate from the engine’s editor bundle.

## After upgrading Ruby or Rails

Run `bundle install`, `bin/rails db:migrate`, and any Maglev install tasks noted in the release notes. Clear boot cache if Spring or Zeitwerk caches stale paths (`bin/spring stop` if you use Spring).
