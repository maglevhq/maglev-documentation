---
title: Section
order: 5
---

# Section

A `section` belongs to a theme and a category.

When a content editor adds a section to a page, Maglev creates a unique instance of that section from its definition. The instance stores the content (text, images, links, and so on) the editor enters.

The section definition tells the editor how to build the content form.

When you generate a new section with the Rails generator, you get a folder structure like this:

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
A section’s id is the **base name** of its definition file (for example, `heroe_01` for `heroe_01.yml`).
{% endhint %}

## Definition file

| Attribute name            | Type              | Description                                                                                                                                                                 |
| ------------------------- | ----------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| name                      | string            | Name of the section (displayed in the editor UI)                                                                                                                            |
| category                  | string            | Identifier of the category (declared in the theme.yml file)                                                                                                                 |
| site\_scoped              | boolean           | A section might have the same content all over the site, like a menu or a footer for instance. False by default.                                                            |
| singleton                 | boolean           | If true, only one instance of this section may appear on a page. False by default.                                                                                |
| viewport\_fixed\_position | boolean           | If the section uses `position: fixed` in the page, the editor adjusts the highlighted action bar accordingly.             |
| insert\_at                | string            | `top` or `bottom`. Often omitted in YAML; use for header- or footer-style sections.                                                |
| insert\_button            | boolean           | Display or not the insert section icon at the bottom of the section. By default, `true`.                                                                                    |
| settings                  | array of settings | List of settings (title, background image, ...etc). See the next chapter to see how to define settings.                                                                     |
| blocks                    | array of blocks   | List of block definitions.                                                                                                                                                  |
| blocks\_label             | string            | Label for the block list in the editor (for example, `"Menu items"` for a site menu section). Default: `"Blocks"`. |
| blocks\_presentation      | string            | Possible values: `tree` or `list` (default).  `tree` is useful to build nested menus or tabs.                                                                               |

{% code title="heroe_01.yml" %}
```yaml
name: "Heroe #1"
category: heroes
settings:
- label: "Title"
  id: title
  type: text
  default: My awesome title
- label: "Background image"
  id: background_image
  type: image
  default: "/maglev-placeholder.png"
```
{% endcode %}

## Template

Inside your section template file, you'll have access to a variable named `maglev_section` exposing the content written by the editors.

This object exposes several attributes and methods.

| Attribute / Method | Type  | Description                                                                                                                                                                                          |
| ------------------ | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| wrapper\_tag       |       | <p>Display the wrapping HTML tag with </p><p>the information required by the editor UI.</p><p>To use a tag other than DIV, you can write:</p><p><code>maglev_section.wrapper_tag.section</code> </p> |
| setting\_tag       |       | <p>Display the content of the setting. The first argument is</p><p>the id of your setting. Based on the setting type, it will</p><p>render a specific HTML content.</p>                              |
| blocks             | Array | List of blocks                                                                                                                                                                                       |

The section must be wrapped in a **single** root HTML node (`div`, `section`, and so on). That node carries metadata the editor needs to refresh the section.

{% code title="hero_01.html.erb" %}
```markup
<%= maglev_section.wrapper_tag
      class: 'py-8 px-4',
      style: "background-image: url(#{maglev_section.settings.background_image.url})" do
%>
  <%= maglev_section.setting_tag :title, html_tag: 'h2', class: 'my-css-class' %>
<% end %>
```
{% endcode %}

You can skip the helpers and use plain HTML. The same section can be written like this:

{% code title="heroe_01.html.erb" %}
```markup
<div
  class="py-8 px-4"
  style="background-image: url(<%= maglev_section.settings.background_image.url %>)"
  <%= maglev_section.dom_data %>
>
  <h2 <%= maglev_section.settings.title.dom_data %> class="my-css-class">
    <%= raw maglev_section.settings.title %>
  </h2>
</div>
```
{% endcode %}
