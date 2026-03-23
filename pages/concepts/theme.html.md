---
title: Theme
order: 3
---

# Theme

Each Maglev site uses a **`theme`**. The theme holds your section definitions and how they are organized.

You cannot create a site without a theme.

{% hint style="info" %}
The MIT version of Maglev comes with a single theme and it's not possible to add another theme. \
To enable the **multi-sites / multi-themes** functionalities, you need the licensed version.

Please [contact us](https://www.maglev.dev/contact) for more details.
{% endhint %}

When you install Maglev, the generators add a small set of files.

```
Rails app root
└── app
    ├── ...
    ├── controllers
    ├── ...
    └── theme
        ├── sections
        └── theme.yml
    └── views
        ├── ...
        └── theme
            ├── sections
            └── layout.html.erb

```

## Definition file

The `theme.yml` file describes the definition (name, description, ...etc) of the theme.

| Attribute name      | Type                      | Description                                                                                                                   |
| ------------------- | ------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| id                  | string                    | Theme identifier. Change it with caution, especially if you already have pages using sections from the previous theme. |
| name                | string                    | Name of the theme (shown in the Maglev UI).                                                                                |
| description         | string                    | Description of the theme (shown in the Maglev UI).                                                                         |
| section\_categories | array of hashes (id/name) | List of section categories. Required by the editor for the section picker.                                                    |
| pages               | array of hashes           | Default pages created when a site is provisioned. Especially relevant for the PRO version of Maglev.                              |

Quick example:

```yaml
id: "theme"

name: "Default theme"

description: "The default Maglev theme"

section_categories:
- name: Heroes
  id: heroes
- name: Calls to action
  id: cta
- name: Carousels
  id: carousels

pages:
- title: "Home page"
  path:  "/index"
```

## Template

Maglev renders `layout.html.erb` for themed pages.

At minimum, include the following **ERB** in that file:

{% code title="layout.html.erb" %}
```markup
<main data-maglev-dropzone>
  <%= raw render_maglev_sections site: @site, theme: @theme, page: @page, page_sections: @page_sections %>
</main>
```
{% endcode %}

That call renders the page’s sections in order.
