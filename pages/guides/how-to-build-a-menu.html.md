---
title: Build a menu section
order: 6
---

# Build a menu section

In most cases, your site will need to display a menu / navbar to show the pages available to the visitors. A section like this one for instance. 

TODO: show an image hero + navbar

## Simple menu

### Generate the section

First, we've to generate a new section from our terminal. Inside your Rails application folder, type:

```bash
$ bundle exec rails g maglev:section navbar_01 --category=navbars --settings \
logo:image \
block:navbar_item:link:link

```

In other words, we just told Maglev to generate a section named navbar\_01 which will have a logo and a list of navbar items. 

{% hint style="info" %}
Make sure you added the `navbars` category in your `theme.yml` file.
{% endhint %}

### Tweak the section definition

Open the `app/theme/sections/navbar_01.yml` file with your code editor.

Since we want all the pages created by the content editors from the editor UI **to share the same content**, we've to uncomment the line about the `site_scoped` attribute.

{% code title="app/theme/sections/navbar_01.yml" %}
```yaml
# Name of the section displayed in the editor UI
name: "Navbar 01"
...
site_scoped: true
....
blocks_label: "Navbar items"
...
```
{% endcode %}

Next, we want the link for navbar item to have a text that will be modified by the content editor. We could also have appended a text setting to the navbar\_item block type but there is a simpler way: using the `with_text` option of the link setting type.

{% code title="app/theme/sections/navbar_01.yml" %}
```yaml
# Name of the section displayed in the editor UI
name: "Navbar 01"
...
blocks: 
- name: "Navbar item"
  type: navbar_item
  settings:
  - label: "Link"
    id: link
    type: link
    with_text: true
    default: "#"

...
```
{% endcode %}

Then, in order to test our section with non fake content, we will provide some sample content. It's easily done with uncommenting and modifying the last part of the YML file.

{% code title="app/theme/sections/navbar_01.yml" %}
```yaml
# Name of the section displayed in the editor UI
name: "Navbar 01"
...
sample:
  settings:
    logo: "/theme/image-placeholder.jpg"
  blocks: 
  - type: navbar_item
    settings:
      link: 
        text: "Home"
        link_type: "url"
        href: "#"
  - type: navbar_item
    settings:
      link: 
        text: "About us"
        link_type: "url"
        href: "#"
  - type: navbar_item
    settings:
      link: 
        text: "Our products"
        link_type: "url"
        href: "#"
          

```
{% endcode %}

### Write the template

We'll rely on Tailwindcss to style our navbar but we can use any Html/CSS library.

{% code title="app/views/theme/sections/navbar_01.html.erb" %}
```markup
<%= maglev_section.wrapper_tag.div class: 'py-6 md:py-12 px-4 md:px-6' do %>
  <div class="container mx-auto">
    <div class="flex items-center">
      <div class="relative w-32">
        <%= maglev_section.setting_tag :logo %>
      </div>

      <nav class="ml-auto">
        <ul class="flex items-center">
          <% section.blocks.each do |maglev_block| %>
            <%= maglev_block.wrapper_tag.li class: 'ml-8' do %>
              <%= maglev_block.setting_tag :link, class: 'hover:underline' %>
            <% end %>
          <% end %>
        </ul>
      </nav>
    </div>
  </div>
<% end %>
```
{% endcode %}

TODO: how to highlight an active menu item

{% hint style="info" %}
Go to the[ Create a new section](https://docs.maglev.dev/guides/create-a-new-section) documentation page to know how to test and use your section in the editor UI.
{% endhint %}

## Multi-levels menu

There are a few minor differences between the **Simple menu** we built in the previous chapter and this one.

In the section definition, we only have to update the `block_presentation` attribute.

{% code title="app/theme/sections/navbar_01.yml" %}
```yaml
# Name of the section displayed in the editor UI
name: "Navbar 01"
...
site_scoped: true
...
blocks_presentation: "tree"
...
```
{% endcode %}

Next, in the section template, we need to display the children of a navbar items.

{% code title="app/views/theme/sections/navbar_01.html.erb" %}
```markup
<%= maglev_section.wrapper_tag.div class: 'py-6 md:py-12 px-4 md:px-6' do %>
  <div class="container mx-auto">
    <div class="flex items-center">
      <div class="relative w-32">
        <%= maglev_section.setting_tag :logo %>
      </div>

      <nav class="ml-auto">
        <ul class="flex items-center">
          <% section.blocks.each do |maglev_block| %>
            <%= maglev_block.wrapper_tag.li class: 'ml-8 relative' do %>
              <%= maglev_block.setting_tag :link, class: 'hover:underline' %>

              <% if maglev_block.children? %>
                <div class="absolute px-2 py-2">
                  <ul>
                    <% maglev_block.children.each do |nested_maglev_block| %>
                      <%= nested_maglev_block.wrapper_tag.li class: 'my-2' do %>
                        <%= nested_maglev_block.setting_tag :link, class: 'hover:underline' %>
                      <% end %>
                    <% end %>
                  </ul>
                </div>
              <% end %>
            <% end %>
          <% end %>
        </ul>
      </nav>
    </div>
  </div>
<% end %>

```
{% endcode %}

Here is the content we can use to test our section:

{% code title="app/theme/sections/navbar_01.yml" %}
```yaml
# Name of the section displayed in the editor UI
name: "Navbar 01"
...
sample:
  settings:
    logo: "/theme/image-placeholder.jpg"
  blocks: 
  - type: navbar_item
    settings:
      link: 
        text: "Home"
        link_type: "url"
        href: "#"
  - type: navbar_item
    settings:
      link: 
        text: "About us"
        link_type: "url"
        href: "#"
    children:
    - type: navbar_item
      settings:
        link: 
          text: "The company"
          link_type: "url"
          href: "#"
    - type: navbar_item
      settings:
        link: 
          text: "Our team"
          link_type: "url"
          href: "#"
```
{% endcode %}

The difference between this menu sample and the previous one is the adding of a new key (`children`) in the block attributes.

## Menu with different type of navbar items

Coming soon
