---
title: Section
order: 5
---

# Section

A `section` belongs to a theme and a category.

When an content editor adds a section within a page, Maglev creates an unique instance of the section based on its definition. This instance will store the content (text / image / links / ...etc) written by the content editor.

The section definition tells to the Editor UI how to build the content form.

When you genarate a new section through a Rails generator, you end up with the following folder structure.

```
Rails app root
└── app
    ├── ...
    ├── controllers
    ├── ...
    └── theme
        ├── sections
            ├── heroes
                └── heroe_01.yml
            └── cta
                └── cta_01.yml
        └── theme.yml
    └── views
        ├── ...
        └── theme
            ├── sections
                ├── heroes
                    └── heroe_01.html.erb
                └── cta
                    └── cta_01.html.erb
            └── layout.html.erb

```

{% hint style="danger" %}
The id of a section is the base name of their definition file name. Example: heroe\_01 for heroe\_01.yml.
{% endhint %}

## Definition file

| Attribute name            | Type              | Description                                                                                                                                                                 |
| ------------------------- | ----------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| name                      | string            | Name of the section (displayed in the editor UI)                                                                                                                            |
| category                  | string            | Identifier of the category (declared in the theme.yml file)                                                                                                                 |
| site\_scoped              | boolean           | A section might have the same content all over the site, like a menu or a footer for instance. False by default.                                                            |
| singleton                 | boolean           | Indicate if there should be one single instance of this section in a page. False by default.                                                                                |
| viewport\_fixed\_position | boolean           | If the sections has a `fixed` position in the page (ie.: `position: fixed`),  the editor will adjust the position of the highlighted action bar in consequence.             |
| insert\_at                | string            | `top` or `bottom` are the 2 valid possible values here. Commented by default. Useful for the header or footer section types.                                                |
| insert\_button            | boolean           | Display or not the insert section icon at the bottom of the section. By default, `true`.                                                                                    |
| settings                  | array of settings | List of settings (title, background image, ...etc). See the next chapter to see how to define settings.                                                                     |
| blocks                    | array of blocks   | List of block definitions.                                                                                                                                                  |
| blocks\_label             | string            | Name of the list of blocks in the UI editor. For instance, if you built a section to represent the menu of your site, you will name them "Menu items". By default: "Blocks" |
| blocks\_presentation      | string            | Possible values: `tree` or `list` (default).  `tree` is useful to build nested menus or tabs.                                                                               |

{% code title="heroe_01.yml" %}
```yaml
name: "Heroe #1"
category: heroes
- label: "Title"
  id: title
  type: text
  default: My awesome title
- label: "Background image"
  id: background_image
  type: image_picker
  default: "/maglev-placeholder.png"
```
{% endcode %}

## Template

Inside your section template file, you'll have access to a variable named `maglev_section` exposing the content written by the editors.

This variable owns a couple of attributes / methods.

| Attribute / Method | Type  | Description                                                                                                                                                                                          |
| ------------------ | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| wrapper\_tag       |       | <p>Display the wrapping HTML tag with </p><p>the information required by the editor UI.</p><p>To use a tag other than DIV, you can write:</p><p><code>maglev_section.wrapper_tag.section</code> </p> |
| setting\_tag       |       | <p>Display the content of the setting. The first argument is</p><p>the id of your setting. Based on the setting type, it will</p><p>render a specific HTML content.</p>                              |
| blocks             | Array | List of blocks                                                                                                                                                                                       |

>

The section must be wrapped by a single HTML node (DIV, SECTION, ...etc). This node will carry some important information about the section required by the UI editor. Those information are very important in order to refresh its content.

{% code title="hero_01.html.erb" %}
```markup
<%= maglev_section.wrapper_tag
      class: 'py-8 px-4',
      style: "background-image: maglev_section.settings.background-image" do
%>
  <%= maglev_section.setting_tag :title, html_tag: 'h2', class: 'my-css-class' %>
<% end %>
```
{% endcode %}

You've got also the ability to not use our helpers and write plain HTML code instead. The example above can be also written like the following way:

{% code title="heroe_01.html.erb" %}
```markup
<div
  class="py-8 px-4"
  style="background-image: <%= section.settings.background-image %>"
  <%= section.dom_data %>
>
  <h2 <%= section.settings.title.dom_data %> class="my-css-class">
    <%= raw section.settings.title %>
  </h2>
</div>
```
{% endcode %}
