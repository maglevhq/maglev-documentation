---
title: Getting started
order: 2
---

# Getting started

## Installation

🎉 Once you have purchased a [license for Maglev PRO](https://packages.nocoffee.fr/stripe/packages/maglevcms-pro/payment_links/new), you will receive an email containing the license key needed to install the Maglev PRO gem, along with instructions for adding this gem to your application's Gemfile.

{% hint style="info" %}
Your application DB must be created first with `bundle exec rails db:create`
{% endhint %}

Add this line to your application's Gemfile:

```bash
source "https://<your license key>@packages.nocoffee.fr/private" do
  gem "maglevcms-pro", '~> 1.0.0', require: 'maglev/pro'
end

gem 'maglevcms', '~> 2.0.0', require: false
```

**Note:** the license key is the one you got from the email you receive after the purchase. If you deleted the email, no worries, send us an email at [contact@maglev.dev](mailto:contact@maglev.dev).

And then execute:

```bash
$ bundle install
```

## Prepare your app

Execute once the Maglev PRO installation generator within the folder of your rails app and follow screen instructions.

{% hint style="info" %}
To function properly, Maglev PRO needs to identify which of your Rails models will own a Maglev site, as this varies depending on your business. \
👋 If you are unsure, we are here to help you figure it out.
{% endhint %}

```bash
$ bundle exec rails g maglev:install
```

## Create a theme and a first section

Create a first theme

```bash
$ bundle exec rails g maglev:theme Simple
```

and a dummy section

```bash
$ bundle exec rails g maglev:section Dummy --theme=Simple --category=content
```

It's now time to run your Rails app server.

```bash
$ bundle exec rails s
```

Please visit [http://localhost:3000/maglev/admin](http://localhost:3000/maglev/admin), you will see your new theme and section.

## \[OPTIONAL] Embed a default theme in your application

{% hint style="info" %}
The `maglev-hyperui-kit` gem includes a library of marketing sections based on [hyperui](https://www.hyperui.dev/), a free open source tailwindcss components.
{% endhint %}

First, add the Maglev HyperUI kit gem to your Gemfile:

{% code title="Gemfile" %}
```ruby
gem 'maglevcms-hyperui-kit', '~> 1.2.0', require: 'maglev/hyperui'
```
{% endcode %}

Then execute:

```bash
$ bundle install
```

Now, install the theme and assign an id to it (`default` in our example):

```bash
bundle exec rails g maglev:hyperui:install --theme=default
```

## Create programmatically your first site

We'll assume that you want to offer a site for each instance of the **Account** model in your application. Remember that you have made the choice of the parent model during the installation.

We're now going to create a new Maglev site based on the **Simple** theme and link it to one of your accounts.

{% hint style="warning" %}
If you installed the MaglevCMS HyperUI kit theme from the previous chapter, you'll have to replace `simple` by `default`in the next statements.
{% endhint %}

Open your rails console

```bash
$ bundle exec rails c
```

And type the following lines of Ruby code

```ruby
my_account = Account.first
site = my_account.generate_maglev_site(theme: 'simple')
```

{% hint style="info" %}
The `generate_maglev_site` method from the Account model is included in the `app/models/concerns/maglev_site_concern.rb` concern.

Please review the concern and customize it according to your application's specific needs for creating Maglev sites.
{% endhint %} &nbsp;
{% hint style="warning" %}
You'll need to call `.generate_maglev_site` somewhere in your main Rails application (like in a controller action, model callback, rake task or service) to actually create the Maglev site.
{% endhint %}

In order to get the editor UI url, in the Rails console, type:

```ruby
app.maglev.base_editor_url(site_handle: site.handle, host: 'localhost:3000', locale: 'en')
```

It will return an url similar to this one: [http://localhost:3000/maglev/black-wildflower-1100/editor/en/index](http://localhost:3000/maglev/black-wildflower-1100/editor/en/index).

However, most of the time, you will need to generate this link within your main application. If your site is mounted on your Account model, you should write something like:

```erb
<% if account.maglev_site %>
  <%= link_to "Edit site", maglev.base_editor_url(site_handle: account.maglev_site.handle, locale: 'en') %>
<% end %>
```

## Going further

Congratulations, you now have Maglev PRO up and running within your Rails application!

It's time to start writing the sections for your themes 💪🚀.

Please refer to the concepts and guides for more information.
