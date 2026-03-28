---
title: Avo
order: 1
---

# Avo
{% description %}
Step-by-step guide to build a blog with both Maglev and Avo.
{% enddescription %}


[Avo](https://avohq.io/) is a polished admin framework for Rails, often considered a modern alternative to [ActiveAdmin](https://activeadmin.info/). It helps you build a clean back-office to manage your app records with just a few terminal commands.

{% hint style="info" %}
If you prefer to skip the full walkthrough, use this ready-made sample repository: [maglevhq/avo-weblog](https://github.com/maglevhq/avo-weblog).
{% endhint %}

## Create a new Rails app

```bash
rails new weblog -j esbuild --css tailwind -d=postgresql
cd weblog
```

Add the extra gems:

```ruby
gem "image_processing", "~> 1.2"
```

Install Active Storage

```bash
bin/rails active_storage:install
```

Install Action Text

```
bin/rails action_text:install
```

**Add Avo**

```bash
bin/rails app:template LOCATION='https://avohq.io/app-template'
```

## Create your first resource

Generate a post resource

```bash
bin/rails generate resource post title:string content:rich_text
```

{% code title="app/models/post.rb" %}
```ruby
class Post < ApplicationRecord
  validates :title, presence: true

  has_rich_text :content

  has_one_attached :cover_photo
end

```
{% endcode %}

Migrate the database

```bash
bin/rails db:migrate
```

Generate the corresponding Avo resource.

```
rails generate avo:resource post
```

{% code title="app/avo/resources/post_resource.rb" %}
```ruby
class PostResource < Avo::BaseResource
  self.title = :id
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  # add fields here
  field :id, as: :id
  field :title, as: :text, required: true
  field :content, as: :trix
  field :cover_photo, as: :file, is_image: true, link_to_resource: true
end
```
{% endcode %}

```bash
bin/rails s
```

You can now create posts. Open [http://localhost:3000/avo/resources/posts/new](http://localhost:3000/avo/resources/posts/new) and create a few records.

## Install Maglev

Add the **Maglev** gem to your Gemfile:

{% code title="Gemfile" %}
```
gem 'maglevcms', '~> 1.1.7'
```
{% endcode %}

Install Maglev files and create the initial site record in the database.

```bash
bundle install
bin/rails g maglev:install
bin/rails maglev:create_site
```

## Use a local Tailwind CSS config

In your Maglev theme layout (`app/views/theme/layout.html.erb`), replace this line:

{% code title="app/views/theme/layout.html.erb" %}
```html
<script src="https://cdn.tailwindcss.com?plugins=forms,typography,aspect-ratio,line-clamp">
```
{% endcode %}

with:

{% code title="app/views/theme/layout.html.erb" %}
```html
<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,400;0,600;0,700;1,400&display=swap" rel="stylesheet">
```
{% endcode %}

Add the **`font-poppins`** class to the `<body>` tag.

{% code title="app/views/theme/layout.html.erb" %}
```html
...
<body class="font-poppings">
...
```
{% endcode %}

Finally, update `tailwindconfig.js` to register the new font family.

{% code title="tailwindconfig.js" %}
```javascript
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      fontFamily: {
        'poppins': ['"Poppins", sans-serif'],
      },
    },
  },
}
```
{% endcode %}

## Connect Avo and Maglev UIs

In this section, we improve navigation between the Avo and Maglev admin interfaces by adding links in both directions.

### Avo UI: add a link to Maglev

Open `config/initializers/avo.rb`, find `config.main_menu`, and replace it with:

{% code title="config/initializers/avo.rb" %}
```ruby
config.main_menu = -> {
  section "Dashboards", icon: "dashboards" do
    all_dashboards
  end

  section "Resources", icon: "resources" do
    all_resources
  end

  section "Content", icon: "heroicons/outline/document" do
    link_to "Pages", path: "/maglev/editor"
  end
}
```
{% endcode %}

### Maglev UI: add a link back to Avo

Open `config/initializers/maglev.rb` and add:

{% code title="config/initializers/maglev.rb" %}
```ruby
config.title = 'Weblog - Pages'
config.back_action = ->(site) { redirect_to main_app.avo_path }
```
{% endcode %}

## Create a home page with Maglev sections

First, add two section categories to `theme.yml`:

{% code title="app/theme/theme.yml" %}
```yaml
# Please, do not change the id of the theme
id: "theme"

name: "Weblog theme"

description: "A couple of sections tailored for a blog"

section_categories:
- name: nav
- name: hero
- name: blog

# Properties of your theme such as the primary color, font name, ...etc.
style_settings: []

pages:
- title: "Home page"
  path:  "/index"

# List of CSS class names used by your library of icons (font awesome, remixicons, ...etc)
icons: []

```
{% endcode %}

### First section: nav

```bash
bin/rails g maglev:section nav_01 \
--name="Nav #1" \
--category=nav \
--settings logo:image call_to_action:link block:nav_item:link:link
```

This section is special: there should be only one instance per page, the content should be shared across all pages, and it should appear at the top.

Then open `app/theme/sections/nav/nav_01.yml` and update the section definition:

{% code title="app/theme/sections/nav/nav_01.yml" %}
```yaml
[...]
site_scoped: true
[...]
insert_button: false
[...]
insert_at: top
[...]
singleton: true
[...]
sample:
  settings:
    logo: "/theme/logo-placeholder.svg"
    call_to_action: { text: "Action", url: "#" }
  blocks:
  - type: nav_item
    settings:
      link: { text: "Nav item", url: "#" }
```
{% endcode %}

See how it looks: http://localhost:3000/maglev/admin/sections/nav\_01/preview\_in\_frame

It still needs styling. Replace `app/views/theme/sections/nav/nav_01.html.erb` with:

{% code title="app/views/theme/sections/nav/nav_01.html.erb" %}
```html
<%= maglev_section.wrapper_tag.div class: 'py-4 md:py-6 px-6 md:px-0' do %>
  <div class="w-full md:max-w-4xl mx-auto flex justify-between items-center">
    <div class="flex items-center space-x-12">
      <%= link_to maglev_site_link do %>
        <%= maglev_section.setting_tag :logo, class: 'h-10' %>
      <% end %>
      <ul class="flex space-x-8">
        <% section.blocks.each do |maglev_block| %>
          <%= maglev_block.wrapper_tag.li do %>
            <%= maglev_block.setting_tag :link, class: 'hover:text-gray-700' %>
          <% end %>
        <% end %>
      </ul>
    </div>
    <%= maglev_section.setting_tag :call_to_action, class: 'block transition-all bg-orange-500 text-white rounded-full px-6 py-2 hover:scale-105' %>
  </div>
<% end %>
```
{% endcode %}

**Note:** Making our navigation section responsive is not part of this guide.

### Second section: Hero

```bash
bin/rails g maglev:section hero_01 \
--name="Hero #1" \
--category=hero \
--settings title:text background_image:image
```

See how it looks: http://localhost:3000/maglev/admin/sections/hero\_01/preview\_in\_frame

It needs a little bit of styling. Open the `app/views/theme/sections/hero/hero_01.html.erb` file and replace the file with:

{% code title="app/views/theme/sections/hero/hero_01.html.erb" %}
```html
<%= maglev_section.wrapper_tag.div class: 'py-6 md:py-12 px-6 md:px-0 bg-black/60 relative' do %>
  <%= maglev_section.setting_tag :background_image, class: 'absolute inset-0 object-cover h-full w-full mix-blend-overlay' %>
  <div class="container mx-auto">
    <div class="flex items-center justify-center flex-col min-h-[theme(spacing.80)] relative text-white text-center space-y-8">
      <%= maglev_section.setting_tag :title, html_tag: 'h1', class: 'text-4xl font-semibold leading-10' %>
    </div>
  </div>
<% end %>
```
{% endcode %}

Now update the sample data before opening the section in the editor. Edit the `sample` block at the bottom of `app/theme/sections/hero/hero_01.yml`:

{% code title="app/theme/sections/hero/hero_01.yml" %}
```yaml
sample:
  settings:
    title: "Welcome to my blog!"
    background_image: "/theme/image-placeholder.jpg"
  blocks: []
```
{% endcode %}

Now, go to http://localhost:3000/maglev/admin/sections/hero\_01/preview and click on the **Take Screenshot** button.

### Third section: Latest posts

Generate the section files:

```bash
bin/rails g maglev:section latest_posts \
--category=blog \
--settings number_of_posts:select more_link:link
```

Update the section definition (`app/theme/sections/blog/latest_posts.yml`):

{% code title="app/theme/sections/blog/latest_posts.yml" %}
```yml
[...]

settings:
- label: "Number of posts"
  id: number_of_posts
  type: select
  options:
  - label: "Last 2 posts"
    value: "2"
  - label: "Last 3 posts"
    value: "3"
  - label: "Last 4 posts"
    value: "4"
  - label: "Last 5 posts"
    value: "5"
  default: "2"

[...]

sample:
  settings:
    number_of_posts: "2"
    more_link:
      text: "More posts"
      url: "#"
  blocks: []
```
{% endcode %}

Now modify the section template at `app/views/theme/sections/blog/latest_posts.html.erb`:

{% code title="app/views/theme/sections/blog/latest_posts.html.erb" %}
```html
<%= maglev_section.wrapper_tag.div class: 'py-3 md:py-6 px-6 md:px-0' do %>
  <div class="w-full md:max-w-4xl mx-auto">
    <div class="grid grid-cols-2 gap-8 border-y py-8 border-gray-200">
      <% Post.order(:created_at).limit(maglev_section.settings.number_of_posts.value.to_i).each do |post| %>
        <%= link_to main_app.post_path(post), class: 'block group' do %>
          <article class="flex flex-col md:flex-row space-y-4 md:space-y-0 md:space-x-10">
            <div class="bg-gray-100 w-full md:w-32 md:min-w-[theme(spacing.32)] rounded-lg bg-transparent overflow-hidden relative">
              <%= image_tag main_app.url_for(post.cover_photo), class: 'object-cover' %>
            </div>
            <header class="space-y-1">
              <p class="text-gray-400 text-xs uppercase"><%= l post.created_at.to_date, format: :long %></p>
              <h2 class="text-gray-800 text-xl font-semibold group-hover:text-gray-600"><%= post.title %></h2>
            </header>
          </article>
        <% end %>
      <% end %>
    </div>
    <div class="flex justify-end mt-4">
      <div class="group hover:text-gray-600">
        <%= maglev_section.setting_tag :more_link %>
        &nbsp;→
      </div>
    </div>
  </div>
<% end %>
```
{% endcode %}

### Fourth section: Highlighted post

First, register the **posts** collection in Maglev. Open `config/initializers/maglev.rb` and add:

{% code title="config/initializers/maglev.rb" %}
```ruby
config.collections = {
  products: {
    model: 'Post', # name of the ActiveRecord class
    fields: {
      label: :title,
      image: :thumbnail_url
    }
  }
}
```
{% endcode %}

Proceed by defining the **thumbnail\_url** method in our Post model. Open the `app/models/post.rb` file and add:

{% code title="app/models/post.rb" %}
```ruby
def thumbnail_url
  return nil unless cover_photo.attached?
  Rails.application.routes.url_helpers.rails_blob_url(cover_photo, disposition: 'attachment')
end
```
{% endcode %}

**Note:** You may need to add this snippet near the top of `config/environments/development.rb`.

```ruby
Rails.application.default_url_options = { host: 'localhost', port: 3000 }
```

Now generate the section files:

```bash
bin/rails g maglev:section highlighted_post \
--category=blog \
--settings title post:collection_item:posts
```

Update the section definition (`app/theme/sections/blog/latest_posts.yml`):

{% code title="app/theme/sections/blog/latest_posts.yml" %}
```
sample:
  settings:
    title: "Highlighted"
    post: 
      id: first
  blocks: []
```
{% endcode %}

Note: Replace `id: first` with the id of an existing post if you want to preview/test your section against a specific post.

Finally, replace `app/views/theme/blog/highlighted_post.html.erb` with:

{% code title="app/views/theme/blog/highlighted_post.html.erb" %}
```html
<%= maglev_section.wrapper_tag.div class: 'py-6 md:py-12 px-6 md:px-0' do %>
  <% post = maglev_section.settings.post.item %>

  <div class="w-full md:max-w-4xl mx-auto space-y-8">
    <h2 class="uppercase font-bold text-xl">
      <%= maglev_section.setting_tag :title %>
    </h2>

    <%= link_to main_app.post_path(post), class: 'block' do %>
      <article class="flex flex-col md:flex-row space-y-4 md:space-y-0 md:space-x-10">
        <div class="bg-gray-100 w-full md:w-72 md:min-w-[theme(spacing.72)] rounded-lg bg-transparent overflow-hidden relative">
          <%= image_tag main_app.url_for(post.cover_photo), class: 'object-cover' %>
        </div>
        <div class="space-y-4">
          <header class="space-y-1">
            <p class="text-gray-400 text-xs uppercase"><%= l post.created_at.to_date, format: :long %></p>
            <h2 class="text-gray-800 text-2xl font-semibold"><%= post.title %></h2>
          </header>
          <div class="text-sm text-gray-700 leading-6">
            <%= truncate(strip_tags(post.content.to_s), length: 140) %>
          </div>
        </div>
      </article>
    <% end if post %>
  </div>
<% end %>
```
{% endcode %}

## Post template

First, update the main app controller to load site-scoped Maglev sections:

{% code title="app/controllers/application_controller.rb" %}
```ruby
class ApplicationController < ActionController::Base
  include Maglev::StandaloneSectionsConcern
  before_action :fetch_maglev_site_scoped_sections
end
```
{% endcode %}

Then replace `app/views/layouts/application.html.erb` with:

{% code title="app/views/layouts/application.html.erb" %}
```html
<!DOCTYPE html>
<html>
  <head>
    <title>Weblog</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,400;0,600;0,700;1,400&display=swap" rel="stylesheet">

    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_include_tag "application", "data-turbo-track": "reload", defer: true %>
  </head>

  <body class="bg-white font-poppins">
    <%= render_maglev_section :nav_01 %>
    <%= yield %>
  </body>
</html>
```
{% endcode %}

Finally, open the `app/views/posts/show.html.erb`.

{% code title="app/views/posts/show.html.erb" %}
```html
<div class="py-6 md:py-12 px-6 md:px-0 relative">
  <div class="w-full md:max-w-4xl mx-auto space-y-8">
    <div class="space-y-1">
      <h1 class="text-2xl font-bold">
        <%= @post.title %>
      </h1>
      <p class="text-gray-400 text-xs uppercase">
        <%= l @post.created_at.to_date, format: :long %>
      </p>
    </div>

    <%= image_tag main_app.url_for(@post.cover_photo), class: 'object-cover mx-auto' %>
  
    <article class="prose lg:prose-lg max-w-full">
      <%= @post.content %>
    </article>
  </div>
</div>
```
{% endcode %}

## Improvements

Although this guide covers many topics, a few core features are still missing for a fully production-ready blog.

* add an authentication engine for both Avo and Maglev
* create more sections: footer, subscribe, call-to-action, forms, etc.
* complete the HTML/ERB template to list all the posts (+ paginate the lists)
* RSS feeds
* Sitemap
