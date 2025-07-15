---
title: Avo
order: 1
---

# Avo
{% description %}
An example about how to create a blog with both Maglev and Avo.
{% enddescription %}


[Avo](https://avohq.io/) is an improved and more polished alternative of the venerable [ActiveAdmin](https://activeadmin.info/) gem. In short, you build a super clean back-office to manage the records of your application and just by running a few commands in the terminal.

{% hint style="info" %}
If you don't want to go through all the steps, we set up a [Git repository](https://github.com/maglevhq/avo-weblog) for this sample application.
{% endhint %}

## Create a brand new Rails app

```bash
rails new weblog -j esbuild --css tailwind -d=postgresql
cd weblog
```

Add the extra gems:

```ruby
gem "image_processing", "~> 1.2"
```

Install ActiveStorage

```bash
bin/rails active_storage:install
```

Install ActionText

```
bin/rails action_text:install
```

**Add Avo**

```bash
bin/rails app:template LOCATION='https://avohq.io/app-template'
```

## Create your first resource

Create a post resource

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

Update the database

```bash
bin/rails db:migrate
```

Generate the related Avo resource.

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

Awesome, we can now create our posts! Fire your browser, hit  [http://localhost:3000/avo/resources/posts/new](http://localhost:3000/avo/resources/posts/new). Write some posts.

## Installation of Maglev

Add the **Maglev** gem to your Gemfile:

{% code title="Gemfile" %}
```
gem 'maglevcms', '~> 1.1.7'
```
{% endcode %}

Install the files Maglev requires to work and create your site in DB.

```bash
bundle install
bin/rails g maglev:install
bin/rails maglev:create_site
```

## Use our local TailwindCSS config

In the layout of the Maglev theme **app/views/theme/layout.html.erb**, change this line

{% code title="app/views/theme/layout.html.erb" %}
```html
<script src="https://cdn.tailwindcss.com?plugins=forms,typography,aspect-ratio,line-clamp">
```
{% endcode %}

by this one:

{% code title="app/views/theme/layout.html.erb" %}
```html
<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,400;0,600;0,700;1,400&display=swap" rel="stylesheet">
```
{% endcode %}

Add the **font-poppings** class to the body tag.

{% code title="app/views/theme/layout.html.erb" %}
```html
...
<body class="font-poppings">
...
```
{% endcode %}

Finally, modify your **tailwindconfig.js** file to register the new family font.

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

## Tweak Avo / Maglev UIs

In this chapter, we're going to improve a little bit the UX of the Avo and Maglev administration UIs by adding links between the 2 UIs.

### Avo UI: add a link to Maglev

Open the `config/initializers/avo.rb` file and look for the `config.main_menu` statement. Replace it by the following:

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

Open the `config/initializers/maglev.rb` file and add the following lines:

{% code title="config/initializers/maglev.rb" %}
```ruby
config.title = 'Weblog - Pages'
config.back_action = ->(site) { redirect_to main_app.avo_path }
```
{% endcode %}

## Create an home page based on Maglev sections

First, add 2 new section categories in the `theme.yml` file

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

This section is a little bit special because we can have one single instance of it in the page and its content must be the same in all the pages of the site. Moreover, it must be located at the top of the page.

Thus, open the `app/theme/sections/nav/nav_01.yml` file and modify the definition of the nav section like the following:

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

It doesn't look like a navbar, let's change the template of the section here at `app/views/theme/sections/nav/nav_01.html.erb` and replace it with:

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

### Second section: hero

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

Alright, it's looking good. Let's change the sample data before we see the section in action in the editor. Change the sample data at the bottom of the `app/theme/sections/hero/hero_01.yml` file:

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

### Third section: N latests posts

Generate the different files for the section

```bash
bin/rails g maglev:section latest_posts \
--category=blog \
--settings number_of_posts:select more_link:link
```

Tweak the definition of the section (`app/theme/sections/blog/latest_posts.yml`):

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

We're going to modify the HTML template of the section. Open the `app/views/theme/sections/blog/latest_posts.html.erb` file

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

First, we've to register the **posts** collection in Maglev. Open your `config/initializers/maglev.rb` file and add the following lines:

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

**NOTE**: You might have to add the following snippet code at the top of your `config/environments/development.rb` file.

```ruby
Rails.application.default_url_options = { host: 'localhost', port: 3000 }
```

It's now time to generate the different files for the section.

```bash
bin/rails g maglev:section highlighted_post \
--category=blog \
--settings title post:collection_item:posts
```

Tweak the definition of the section (`app/theme/sections/blog/latest_posts.yml`):

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

And lastly, replace the template of the section `app/views/theme/blog/highlighted_post.html.erb` by:

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

## Template of a post

First, we are going to update the main layout of our Rails application. But before that, we have to update the `app/controllers/application_controller.rb` file like this:

{% code title="app/controllers/application_controller.rb" %}
```ruby
class ApplicationController < ActionController::Base
  include Maglev::StandaloneSectionsConcern
  before_action :fetch_maglev_site_scoped_sections
end
```
{% endcode %}

Then, change the `app/views/layouts/application.html.erb` with:

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

Although we've covered a lot of topics, a couple of core features is still missing in order to achieve a fully functional blog.

* add an authentication engine for both Avo and Maglev
* create a lot more sections: footer, subscribe, call to action, forms, ...etc
* complete the HTML/ERB template to list all the posts (+ paginate the lists)
* RSS feeds
* Sitemap
