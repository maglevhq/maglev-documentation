---
title: Theme
order: 3
---

# Theme

A Maglev site is referenced by a `theme` and a `theme` includes sections.

You can't create a site without a theme.

{% hint style="info" %}
The MIT version of Maglev comes with a single theme and it's not possible to add another theme. \
To enable the **multi-sites / multi-themes** functionalities, you need the licensed version.

Please [contact us](https://www.maglev.dev/contact) for more details.
{% endhint %}

During the Maglev installation, a couple of files were added by our generators.

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
| id                  | string                    | Identifier of the theme. You can it but with caution, especially if you've got pages including sections of the previous theme |
| name                | string                    | Name of the theme (displayed in the dev panel)                                                                                |
| description         | string                    | Description of the theme (displayed in the dev panel)                                                                         |
| section\_categories | array of hashes (id/name) | List of section categories. Required by the editor for the section picker.                                                    |
| pages               | array of hashes           | Default pages generated when a site is created. Specifically useful by the PRO version of Maglev                              |

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

The `layout.html.erb` is being rendered by the Maglev CMS functionality.

The minimal requirement is to have the following **ERB** code inside this file:

{% code title="layout.html.erb" %}
```markup
<main data-maglev-dropzone>
  <%= raw render_maglev_sections site: @site, theme: @theme, page: @page, page_sections: @page_sections %>
</main>
```
{% endcode %}

This code is in charge of rendering the list of sections of a page.
