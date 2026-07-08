---
title: Use importmap-rails in a theme
order: 9.5
---

# Use importmap-rails in a theme

{% description %}
How to load your theme JavaScript with importmap-rails alongside the Maglev editor client.
{% enddescription %}

Maglev v3 follows Rails conventions: **Stimulus**, **importmap-rails**, and no mandatory Node bundler for editor code. If your theme also uses **importmap-rails** for section behavior (carousels, accordions, and so on), wire it up in `app/views/theme/layout.html.erb` with the helper described in this guide.

Themes with **no theme JavaScript** do not need this guide — keep using **`maglev_client_javascript_tags`** alone.

## Layout setup

Add your theme’s importmap entry point in the layout `<head>` with **`maglev_javascript_importmap_tags`**:

{% code title="app/views/theme/layout.html.erb" %}
```erb
<head>
  ...

  <%= maglev_javascript_importmap_tags 'my-entry-point' %>

  ...
</head>
```
{% endcode %}

The helper accepts the same **`entry_point`** argument as `javascript_importmap_tags` and an optional **`importmap:`** keyword argument if you need to pass a custom importmap object (defaults to `Rails.application.importmap`).

| Mode | Behavior |
| --- | --- |
| **Non-editor** (normal site visit) | Transparent pass-through to `javascript_importmap_tags` — no Maglev client code is injected. |
| **Editor** (page loaded in the editor iframe) | Importmaps are merged; both `import "my-entry-point"` and `import "maglev-client"` are emitted. |

## Why not call both helpers separately?

The previous pattern called **`javascript_importmap_tags`** and **`maglev_client_javascript_tags`** side by side:

{% code title="layout.html.erb (avoid this pattern)" %}
```erb
<%= javascript_importmap_tags 'my-entry-point' %>
<%= maglev_client_javascript_tags %>
```
{% endcode %}

That breaks in **Firefox** with:

> Uncaught TypeError: The specifier "maglev-client" was a bare specifier, but was not remapped to anything.

Firefox strictly follows the HTML spec, which allows only **one** `<script type="importmap">` per document and silently ignores any subsequent ones. With the pattern above, the theme emits importmap #1 and Maglev’s client emits importmap #2 — Firefox discards the second, so `import "maglev-client"` has no mapping.

Chrome already merges multiple importmaps per document, which is why the issue may only appear in Firefox.

**`maglev_javascript_importmap_tags`** replaces both calls. It merges the Maglev client importmap entries into the theme’s importmap so that only a single `<script type="importmap">` is ever emitted. This landed in [maglev-core PR #244](https://github.com/maglevhq/maglev-core/pull/244).

If you hit this error in the editor, see also [Troubleshooting — Firefox: `maglev-client` bare specifier error](/guides/troubleshooting#firefox-maglev-client-bare-specifier-error).

## Browser support note

Chrome already supports multiple importmaps per document (merged). Once Firefox ships the same support, this helper can be simplified back to two separate calls.
