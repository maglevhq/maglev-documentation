---
title: Migrate from Maglev PRO
order: 3
---

# Migrate from Maglev PRO

If you run a **multi-site** platform on the **Maglev PRO** gem (`maglevcms-pro`, Maglev v2), the v3 path is the **Maglev SaaS plugin** (`maglevcms-saas-plugin`). The product model is the same; the gem and Maglev core version change.

{% hint style="warning" %}
**Back up first.** Take a full backup of your database and uploaded assets before upgrading, so you can roll back if anything goes wrong.
{% endhint %}

## What you need

After your subscription is updated, you should receive:

- **Private gem access** — `maglevcms-saas-plugin` from the [packages.nocoffee.fr](https://packages.nocoffee.fr) gem repository (same channel as Maglev PRO).
- **GitHub access** — the plugin source at [maglevhq/maglev-saas-plugin](https://github.com/maglevhq/maglev-saas-plugin) (useful for reading install details and comparing with your app).

**Reference apps**

- Live demo: [demo-pro.maglev.dev](https://demo-pro.maglev.dev) (runs the SaaS plugin in production).
- Demo source: [maglevhq/site-builder-demo](https://github.com/maglevhq/site-builder-demo) — compare its `Gemfile`, routes, and initializers with your application.

If anything is missing, contact [contact@maglev.dev](mailto:contact@maglev.dev).

## Migration steps

The upgrade is mostly a **Gemfile swap** plus the standard **Maglev v2 → v3** core upgrade.

### 1. Update the Gemfile

Remove **Maglev PRO** and add the **SaaS plugin**. Bump **Maglev core** to v3.

**Before (Maglev PRO + v2):**

{% code title="Gemfile" %}

```ruby
source "https://<your-credentials>@packages.nocoffee.fr/private" do
  gem "maglevcms-pro", "~> 1.0.2", require: "maglev/pro"
end

gem "maglevcms", "~> 2.0.0", require: false
```

{% endcode %}

**After (SaaS plugin + v3):**

{% code title="Gemfile" %}

```ruby
source "https://<your-credentials>@packages.nocoffee.fr/private" do
  gem "maglevcms-saas-plugin", "~> 0.1.0"
end

gem "maglevcms", "~> 3.0.2"
```

{% endcode %}

{% hint style="info" %}
**Do not use `require: false` on `maglevcms`** when the SaaS plugin is installed. If your Gemfile still has it from a PRO or single-site setup, remove it—otherwise the engine may not load correctly.
{% endhint %}

Use the **version constraints** you received with your package access if they differ from the examples above.

### 2. Install gems

```bash
bundle install
```

### 3. Apply Maglev v3 changes

Follow the [From v2 to v3](/guides/upgrades#from-v2-to-v3) section of the upgrades guide. In short:

```bash
bundle exec rails maglev:install:migrations
bundle exec rails db:migrate
bundle exec rails maglev:publish_site
```

Also review v3-only changes there (editor layout overrides, section thumbnails, theme layout tags, and so on).

### 4. Smoke-test your platform

- Sign in and open the editor for an existing site.
- Create a new site (if your flow uses `generate_maglev_site` or equivalent).
- Confirm published pages render for visitors.

If something fails, diff your app against [site-builder-demo](https://github.com/maglevhq/site-builder-demo) and the plugin repo.

## What usually carries over

- The **tenant model** and **site ownership** pattern you configured for PRO (for example `Account` + `maglev_site_concern`).
- **Themes and sections** in `app/theme/` and `app/views/theme/` — you may need small v3 adjustments; see [Upgrades](/guides/upgrades) and [Concepts](/concepts/overview).
- **Programmatic site creation** — `generate_maglev_site` and editor URL helpers remain the same idea; confirm method names against your routes and the reference demo.

## Need help?

Email [contact@maglev.dev](mailto:contact@maglev.dev) with your app’s Maglev and Rails versions and any error output from `bundle install` or boot.
