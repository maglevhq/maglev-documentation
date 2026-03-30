---
title: Getting started
order: 2
---

# Getting started

## Installation

The SaaS plugin is distributed from the **NoCoffee private gem server**. After you have access, add the private source and gems to your **Gemfile** (exact version constraints are given with your subscription).

{% hint style="info" %}
Your application database must exist before running installers: `bundle exec rails db:create`
{% endhint %}

Add lines similar to the following (replace the source URL and credentials with those you received):

{% code title="Gemfile" %}

```ruby
source "https://<your-credentials>@packages.nocoffee.fr/private" do
  gem "maglevcms-saas-plugin", "~> 0.1.0"
end

gem "maglevcms", "~> 3.0.0", require: false
```

{% endcode %}

Then install:

```bash
bundle install
```

{% hint style="info" %}
**Reference implementation:** the [site-builder-demo](https://github.com/maglevhq/site-builder-demo) app pins `maglevcms` and `maglevcms-saas-plugin` from GitHub for development; your production setup will normally use released gems from the private server. Compare its `Gemfile`, initializers, and routes with your app when integrating.
{% endhint %}

If you need access or credentials, contact [contact@maglev.dev](mailto:contact@maglev.dev).

## Prepare your app

Run the Maglev installer once from your Rails app and follow the prompts.

{% hint style="info" %}
The SaaS plugin needs to know which **Rails model** owns a Maglev site (for example `Account` or `User`). That choice is specific to your product; the installer and concern stubs reflect it.
{% endhint %}

```bash
bundle exec rails g maglev:install
```

## Create a theme and a first section

Create a first theme:

```bash
bundle exec rails g maglev:theme Simple
```

and a sample section:

```bash
bundle exec rails g maglev:section Dummy --theme=Simple --category=content
```

Start the app:

```bash
bundle exec rails s
```

Open the Maglev admin/editor URLs your app exposes after install (paths can differ from single-site Maglev; align with your routes and the reference repo).

## [Optional] Embed a default theme (HyperUI kit)

{% hint style="info" %}
The `maglevcms-hyperui-kit` gem ships marketing-oriented sections based on [HyperUI](https://www.hyperui.dev/) (Tailwind CSS). Versions align with Maglev v3; check your Gemfile against [Quickstart](/quickstart) for current constraints.
{% endhint %}

Add the kit to your Gemfile, install, then run the HyperUI installer (see [Quickstart](/quickstart) for exact commands and `--theme` naming).

## Create your first site programmatically

Assume each **Account** (or the model you configured at install) should get a Maglev site. Create a site from a theme id (use `default` if you installed HyperUI as `default`, otherwise your theme name, e.g. `simple`):

```bash
bundle exec rails c
```

```ruby
my_account = Account.first
site = my_account.generate_maglev_site(theme: "simple")
```

{% hint style="info" %}
`generate_maglev_site` is provided by the concern the installer adds (for example `app/models/concerns/maglev_site_concern.rb`). Adjust it to match how your app provisions tenants.
{% endhint %}

{% hint style="warning" %}
Call `generate_maglev_site` from real application code (controller, service, callback, or job)—not only from the console—when a new tenant should receive a site.
{% endhint %}

To build an editor URL for a site, use the helpers your app defines after install. The PRO-era pattern looked like:

```ruby
app.maglev.editor_root_url(site_handle: site.handle, host: "localhost:3000", locale: "en")
```

In your views, linking might resemble:

```erb
<% if account.maglev_site %>
  <%= link_to "Edit site", maglev.editor_root_url(site_handle: account.maglev_site.handle, locale: "en") %>
<% end %>
```

Confirm the helper names and path structure against your generated routes and the [site-builder-demo](https://github.com/maglevhq/site-builder-demo) source.

## Going further

You now have Maglev core plus the SaaS plugin wired into your app. Next steps: design themes and sections, then use the [Concepts](/concepts/overview) and [Guides](/guides/create-a-new-section) sections of this documentation—the same building blocks apply to multi-site setups.
