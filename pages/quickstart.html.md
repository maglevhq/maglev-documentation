---
title: Quickstart
order: 2
---

# Quickstart

{% description %}
Install the open source (single-site) edition of Maglev v3 in a Ruby on Rails application.
{% enddescription %}

This guide covers two paths: a **Rails application template** (fastest for a greenfield app) or **manual setup** (better when adding Maglev to an app you already have).

{% hint style="info" %}
**Requirements**

- Ruby 3+
- Ruby on Rails 7.2 or newer (the template below generates a **Rails 8** app)
- PostgreSQL, SQLite, MySQL, or MariaDB
- ImageMagick or libvips (for image processing in Active Storage)
  {% endhint %}

## Option A — Rails template (about a minute)

The official template creates a new **Rails 8** application with Maglev and the HyperUI-based section library preconfigured.

```bash
rails new my-awesome-site \
  -m https://raw.githubusercontent.com/maglevhq/maglev-core/master/template.rb \
  --skip-action-cable

cd my-awesome-site
bundle exec rails server
```

When the server is running, open the site at [http://localhost:3000/](http://localhost:3000/). A sample home page is created for you.

To edit pages in the visual builder, use [http://localhost:3000/maglev/editor](http://localhost:3000/maglev/editor).

## Option B — Manual setup (new or existing Rails app)

Use this path if you prefer full control or are **adding Maglev to an existing project**.

### 1. Rails app and database

Create a new app (skip this if you already have one):

```bash
rails new my-awesome-site --skip-action-cable
cd my-awesome-site
bundle exec rails db:create
```

{% hint style="info" %}
Pass `--database=postgresql` to `rails new` if you want PostgreSQL by default.
{% endhint %}

### 2. Active Storage

Maglev uses Active Storage for media uploads. Install and migrate:

{% hint style="warning" %}
Uncomment **`gem 'image_processing', '~> 1.3'`** in your Gemfile (or add it). Image processing is strongly recommended for responsive images.
{% endhint %}

```bash
bundle exec rails active_storage:install
bundle exec rails db:migrate
```

### 3. Gems

Add Maglev and the HyperUI kit to your **Gemfile**, then install:

{% code title="Gemfile" %}

```ruby
gem 'maglevcms', '~> 3.0.0'
gem 'maglevcms-hyperui-kit', '~> 2.0.0'
```

{% endcode %}

```bash
bundle install
```

{% hint style="info" %}
**maglevcms-hyperui-kit** ships ready-made marketing sections built from [HyperUI](https://www.hyperui.dev) (Tailwind CSS).
{% endhint %}

### 4. Generators and site record

```bash
bundle exec rails g maglev:install
bundle exec rails g maglev:hyperui:install --force
bundle exec rails maglev:create_site
bundle exec rails maglev:publish_site
```

### 5. Run the app

```bash
bundle exec rails server
```

Visit [http://localhost:3000/](http://localhost:3000/) for the preview site and [http://localhost:3000/maglev/editor](http://localhost:3000/maglev/editor) for the editor—the same as in Option A.
