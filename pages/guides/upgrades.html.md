---
title: Upgrades
order: 11
---

# Upgrades

## From v2 to v3

{% hint style="info" %}
Maglev v3 drops the Node.js toolchain thanks to Hotwire, Stimulus, and Rails import maps. You can manage the entire frontend from Ruby and the asset pipeline.
{% endhint %}

Follow these steps to upgrade an existing Maglev v2 installation to v3 beta:

1. **Update dependencies**
   - Update the `maglevcms` entry in your application's `Gemfile` by pointing to the **3.0.0** version.

     ```ruby
     gem "maglevcms", "~> 3.0.0"
     ```

   - Run `bundle install` to install the new version.

2. **Install the new migrations**
   - Execute `bundle exec rails maglev:install:migrations` in your main app.

3. **Run the migrations**
   - Apply them with `bundle exec rails db:migrate`.

4. **Publish existing pages**
   - Maglev v3 only renders pages that are published. Publish the whole site once:

     ```bash
     bundle exec rails maglev:publish_site
     ```

5. **Update any custom editor header**
   - If you override the editor header, move `app/views/maglev/editor/_header.html.erb` to `app/views/layouts/maglev/editor/_head.html.erb`.

## From v1 to v2

Nothing to do.

## From v1.0.x to v1.1.x

Your theme layout must include an extra **JavaScript** tag in the `<head>`.\
That script handles communication between themed pages and the Maglev editor (live preview).

```erb
<!DOCTYPE html>
<html>
<head>
  <title><%= maglev_page.seo_title.presence || maglev_site.name %></title>

  ....

  <%= maglev_live_preview_client_javascript_tag %>

  ....
```
