---
title: Personalize the editor
order: 3
---

# Personalize the editor

We designed the Editor UI in a minimalist way so that most content editors will quickly be able to edit the content of their site without too much help.

## Tweak the Editor UI

We went a little further than that. Developers can also tweak the UI to enhance the feeling that content editors are at home. It means that all the references to Maglev displayed in the UI can be replaced by custom content.

By default, here is a quick sample of the Editor UI:

![the Maglev Editor UI with the default style.](pages/personalize-the-editor-1.jpg)

Maglev’s installer adds `config/initializers/maglev.rb` to your app.

```ruby
Maglev.configure do |c|
  # Title of the Editor window
  c.title = 'Editing my site'

  # Logo of the Editor (top left corner).
  # Put your custom logo in the app/assets/images folder of your Rails application.
  c.logo = 'logo.png'

  # Favicon (window tab)
  # Put your custom favicon in the app/assets/images folder of your Rails application.
  c.favicon = 'favicon.ico'

  # Primary color of the Editor
  c.primary_color = '#FBBF24'

  # Action triggered when clicking on the very bottom left button in the Editor
  # c.back_action = 'https://www.myapp.dev' # External url
  # c.back_action = :my_account_path # name of the route in your Rails application
  # c.back_action = ->(site) { redirect_to main_app.my_account_path(site_id: site.id) }

  # I18n locale used in the Editor UI (by default, I18n.locale will be used)
  # config.ui_locale = 'fr' # make sure your locale has been registered in Rails.
  # config.ui_locale = :find_my_locale # name of a protected method from your Rails application controller
  # config.ui_locale = ->(site) { 'fr' }

  # Uploader engine (:active_storage is only supported for now)
  # c.uploader = :active_storage

  # Pagination for page lists and the assets modal (optional)
  # c.pagination = { pages: -1, assets: 16 } # -1 means no pagination for pages

  # When you customize the Editor UI (e.g. extra ERB) with Tailwind classes that are
  # not in Maglev’s default bundle, add folders here so the Tailwind watcher scans them.
  # c.tailwindcss_folders = [Rails.root.join('app/views/maglev/editor')]
end

```

\
By modifying the values within this file, you will be able to achieve something like this:

![the Maglev Editor UI with a different logo, tab title and primary color.](pages/personalize-the-editor-2.jpg)

## Pagination

You can tune how the editor loads long lists by setting `pagination` in `config/initializers/maglev.rb`. Pass a hash with any of the following keys:

- **`pages`** — Pagination for the site’s page list in the editor. Use `-1` to disable pagination and load every page at once.
- **`assets`** — How many assets appear per page in the assets picker modal.

```ruby
Maglev.configure do |config|
  config.pagination = {
    pages: -1,
    assets: 16
  }
end
```

## Tailwind CSS watch folders

This option is for when you **change the Editor UI itself**—for example by adding or overriding templates (ERB) in your Rails app. Those templates may use Tailwind utility classes that never appear in Maglev’s built-in editor markup, so they would be missing from the default editor CSS bundle. Listing directories with `tailwindcss_folders` tells the Tailwind watcher to scan those files and include any utilities it finds there.

```ruby
Maglev.configure do |config|
  config.tailwindcss_folders = [
    Rails.root.join('app/views/maglev/editor')
  ]
end
```

Use paths that match where your editor-facing views or partials actually live.

## Translate theme labels (categories, section/block settings)

While the `label` property of a section defines the default text displayed in the editor UI, you can translate these labels by adding translations to your main application's locale files. The translations follow a specific naming convention under the `maglev.themes` namespace.

### Translation structure

In your Rails app, add entries under `config/locales/<locale>.yml` using this structure:

```yaml
[locale]:
  maglev:
    themes:
      [theme_name]:
        categories:
          [category_id]:
            name: "Translated category name"
        sections:
          [section_name]:
            settings:
              [setting_id]: "Translated Label"
              [setting_id]_options:
                [option_value]: "Translated Option Value"
            blocks:
              label: "Translated blocks tab label"
              types:
                [block_type]: "Translated block type name"
```

### Example

For instance, if you want to translate the "title" setting label of a "showcase" section in a theme named "simple":

```yaml
en:
  maglev:
    themes:
      simple:
        categories:
          showcase:
            name: "Showcase 😎"
        sections:
          showcase:
            settings:
              title: "Title 😎"
```

You can also translate block labels and block types. For example, to translate the blocks tab label and block types for a "navbar" section:

```yaml
en:
  maglev:
    themes:
      simple:
        sections:
          navbar:
            blocks:
              label: "Menu 🍔"
              types:
                menu_item: "Menu item 👩🏽‍🍳"
                alt_menu_item: "Alt Menu item 🍪"
```

The system will automatically pick up these translations in the editor interface when displaying setting labels, block labels, and block type names. If no translation is found, it will fall back to the `label` value defined in the section's YAML file.

## Select setting type examples

The `select` setting type is particularly useful for providing content editors with predefined choices. Here are some practical examples of how to implement it:

### Basic select with options

```yaml
settings:
  - label: "Menu style"
    id: menu_style
    type: select
    select_options:
      - label: "Option 1"
        value: "option1"
      - label: "Option 2"
        value: "option2"
    default: "option1"
```

### Localizing select options

For multi-language support, use the translation files with the `{setting_id}_options` structure. Given this select setting:

```yaml
settings:
  - label: "Alignment"
    id: alignment
    type: select
    select_options:
      - label: "Left"
        value: left
      - label: "Center"
        value: center
      - label: "Right"
        value: right
```

You can translate it like this:

```yaml
en:
  maglev:
    themes:
      simple:
        sections:
          jumbotron:
            settings:
              alignment: "Alignment 📏"
              alignment_options:
                left: "Left 🍪"
                center: "Center 👩🏽‍🍳"
                right: "Right 🍔"
```

These examples show how the select setting type can be used to create user-friendly dropdown menus in the editor interface, with proper localization support through translation files.
