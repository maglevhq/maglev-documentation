---
title: Personalize the editor
order: 3
---

# Personalize the editor

We designed the Editor UI in a minimalist way so that most content editors will quickly be able to edit the content of their site without too much help.

## Tweak the Editor UI

We went a little further than that. Developers can also tweak the UI to enhance the feeling that content editors are at home. It means that all the references to Maglev displayed in the UI can be replaced by custom content.

By default, here is a quick sample of the Editor UI:

![the Maglev Editor UI with the default style.](https://1311630049-files.gitbook.io/~/files/v0/b/gitbook-legacy-files/o/assets%2F-Me54MJUO0o8Vj5WCTWJ%2F-MeUwrTI6TuqN8mdhZtm%2F-MekxQC_Ueu6lgqhQ9BW%2Feditor-ui-default.jpg?alt=media\&token=58e1782a-00c2-4b29-8ff3-0988a90d7517)

During the Maglev installation, a new file was added in your Rails application at the following location `config/initializers/maglev.rb`.

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
end

```

\
By modifying the values within this file, you will be able to achieve something like this:

![the Maglev Editor UI with a different logo, tab title and primary color.](https://1311630049-files.gitbook.io/~/files/v0/b/gitbook-legacy-files/o/assets%2F-Me54MJUO0o8Vj5WCTWJ%2F-Meky-08rSTvfQFlN8BU%2F-MekzuL2AfyRgp1mr5nM%2Feditor-ui-custom.jpg?alt=media\&token=c604749f-8631-4f2c-82c4-f04aa152bba4)

## Translate theme labels (categories, section/block settings)

While the `label` property of a section defines the default text displayed in the editor UI, you can translate these labels by adding translations to your main application's locale files. The translations follow a specific naming convention under the `maglev.themes` namespace.

### Translation structure

In your RoR application, add your translations in your locale files (config/locales/\[locale].yml) following this structure:

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

The system will automatically pick up these translations in the editor interface when displaying setting labels. If no translation is found, it will fall back to the `label` value defined in the section's YAML file.
