---
title: Quick start
order: 2
---

# Quick start
{% description %}
Instructions to install the single-site version (or MIT version) of Maglev
{% enddescription %}


{% hint style="info" %}
**Requirements**:\
- Ruby 3+\
- Ruby on Rails 7+\
- Postgresql or SQLite\
- ImageMagick or libvips\
- Node 20+
{% endhint %}

### Short version (1 minute installation) 😎

We wrote a Rails application template which will generate a brand new **Ruby on Rails 8** application with Maglev already setup. 

```bash
$ rails new my-awesome-site \
  -m https://raw.githubusercontent.com/maglevhq/maglev-core/master/template.rb \
  --skip-action-cable
  
$ cd my-awesome-site
$ bundle exec rails server
```

🎉 Congratulations! A random home page has been initialized with some content, check it out here: [http://localhost:3000/](http://localhost:3000/) 

If you want to modify the content, go to this url: [http://localhost:3000/maglev/editor](http://localhost:3000/maglev/editor). 🚀

### Long version 🤓

First generate a new Ruby on Rails application. You can skip this step if you've got an existing application.

```bash
$ rails new my-awesome-site --database=postgresql --skip-action-cable
$ cd my-awesome-site
$ bundle exec rails db:create
```

{% hint style="info" %}
Remove `--database=postgresql` if you'd like to use SQLite instead.
{% endhint %}

Maglev depends on ActiveStorage for the content asset uploading. So you need to setup ActiveStorage like this:

{% hint style="warning" %}
We strongly recommend to enable the **image\_processing** gem in your Gemfile.\
Please uncomment the line `gem 'image_processing', '~> 1.3'`
{% endhint %}

```bash
$ bundle exec rails active_storage:install
$ bundle exec rails db:migrate
```

Add now the Maglev engine to your app Gemfile file. 

{% code title="Gemfile" %}
```ruby
gem 'maglevcms', '~> 2.0.0'
gem 'maglevcms-hyperui-kit', '~> 1.2.0'
```
{% endcode %}

{% hint style="info" %}
the `maglev-hyperui-kit` gem includes a library of marketing sections based on [hyperui](https://www.hyperui.dev), a free open source tailwindcss components.  
{% endhint %}

Setup Maglev

```bash
$ bundle exec rails g maglev:install
$ bundle exec rails g maglev:hyperui:install --force
$ bundle exec rails maglev:create_site
```

Launch your rails app

```bash
$ bundle exec rails s
```

🎉 Congratulations! A random home page has been initialized with some content, check it out here: [http://localhost:3000/](http://localhost:3000/) 

If you want to modify the content, go to this url: [http://localhost:3000/maglev/editor](http://localhost:3000/maglev/editor). 🚀
