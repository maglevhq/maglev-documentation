---
title: Setting
order: 6
---

# Setting

A `section` or `block` definition comes with a list of `settings`. Those settings will be used by the **editor UI** to render the proper content form of a section (or block).

For instance, if your section has two settings—a title (`text`) and a background image (`image`)—the editor renders a form with a text field and an image picker.

## Default definition setting attributes

| Name      | Type    | Description                                                                                                                                                                                               |
| --------- | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| label     | string  | Label displayed in the editor UI as the input label.                                                                                                                                                      |
| id        | string  | Identifier of the setting. Use it in templates to read the value. Must be unique among the settings of that section or block.              |
| type      | string  | Which kind of input the editor renders. See the list of available types below.                                                                                                          |
| default   | string  | <p>When a section or a block is added to the page, in order to avoid blank content, Maglev will fill the section or block content with the default value of each setting. </p><p>A value is required.</p> |
| advanced | boolean | If the setting is not content-related, the editor shows it on a separate tab in the section form.                                                                                        |

## Available types and their options

### text

Display a text input, simple or a rich text editor depending on the setting options.

**Definition:**

| Option      | Type    | Description                                                                                                                                                                   |
| ----------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| html        | boolean | Enable the rich text editor for this setting. False by default.                                                                                                               |
| line\_break | boolean | If true (and if the `html` option is also true), will cause the carriage return (enter key) to generate a `<br>` tag instead of closing the current element. False by default |
| nb\_rows    | integer | Number of rows for the rich text editor.                                                                                                                                      |

{% code title="app/theme/sections/sample.yml" %}
```yaml
settings:
- label: "Title"
  id: title
  type: text
  # html: true
  # line_break: true
  # nb_rows: 5
```
{% endcode %}

**Usage in the HTML/ERB template:**

{% tabs %}
{% tab title="Template" %}
{% code title="app/views/theme/sections/sample.html.erb" %}
```markup
<%= maglev_block.setting_tag :title, html_tag: :h2 %>
```
{% endcode %}
{% endtab %}

{% tab title="Raw template" %}
```markup
<h2 <%= section.settings.title.dom_data %>>
  <%= raw section.settings.title %>
</h2>
```
{% endtab %}
{% endtabs %}

### image

Display an image picker to let the content editor choose or upload any image.

**Definition:**

{% code title="app/theme/sections/sample.yml" %}
```yaml
settings:
- label: "Screenshot"
  id: screenshot
  type: image
  default: "/samples/images/default.svg"
```
{% endcode %}

**Usage in the HTML/ERB template:**

{% tabs %}
{% tab title="Template" %}
{% code title="app/views/theme/sections/sample.html.erb" %}
```markup
<%= maglev_section.setting_tag :screenshot, class: 'my-css-class' %>
```
{% endcode %}
{% endtab %}

{% tab title="Raw template" %}
```markup
<img
    <%= section.settings.screenshot.dom_data %>
    src="<%= section.settings.screenshot %>"
    alt="<%= section.settings.screenshot.alt_text %>"
    class="my-css-class"
/>
```
{% endtab %}
{% endtabs %}

**List of properties:**

```markup
<p><img src="<%= maglev_section.settings.screenshot.url %>" alt="<%= maglev_section.settings.screenshot.alt_text %>" /></p>
```

| Property  | Type    | Description                                |
| --------- | ------- | ------------------------------------------ |
| url       | string  | URL of the image                           |
| width     | integer | Width of the original image (in px)        |
| height    | integer | Height of the original image (in px)       |
| alt\_text | string  | Alternate text added by the content editor |
| to\_s     | string  | Alias of the `url` method                  |

### link

Display a link picker. The content editor will have the choice between a link to an external URL, a page or an email address.

**Definition:**

| Option     | Type    | Description                                                                                                                               |
| ---------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| with\_text | Boolean | <p>False if you only need a URL.<br>Otherwise, the editor also shows a text field <br>in addition to the URL picker.</p> |

{% code title="app/theme/sections/sample.yml" %}
```yaml
settings:
- label: "Call to action"
  id: cta_link
  type: link
  with_text: true
  default: "/"
```
{% endcode %}

**Usage in the HTML/ERB template:**

{% tabs %}
{% tab title="Template" %}
{% code title="app/views/theme/sections/sample.html.erb" %}
```markup
<%= maglev_section.setting_tag :cta_link %>
```
{% endcode %}
{% endtab %}

{% tab title="Template without text" %}
```markup
<%= maglev_section.setting_tag :cta_link do %>
   Call us
<% end %>
```
{% endtab %}

{% tab title="Raw template (without text)" %}
```markup
<a
  href="<%= section.settings.cta_link.href %>"
  <% if section.settings.cta_link.open_new_window? %>target="_blank"<% end %>
>
  Call us
</a>
```
{% endtab %}
{% endtabs %}

**List of properties:**

| **Property**       | Type    | Description                                                                           |
| ------------------ | ------- | ------------------------------------------------------------------------------------- |
| href               | String  | URL of the page / external URL / email address.                                       |
| text               | String  | Text from the editor when the `with_text` option is enabled. |
| open\_new\_window? | Boolean | True if the content editor wants the link to be opened in a new browser tab.          |
| target\_blank      | String  | Returns `_blank` or nil depending on the property above.                              |
| to\_s              | String  | Alias of the `href` property.                                                         |
| with\_text?        | Boolean | True if the setting has the `with_text` option enabled.                               |
| active?            | Boolean | True if the link is active (when `link_type` is 'page' and matches current page).     |
| link_type          | String  | Type of link: 'url', 'page', or other custom types.                                   |
| link_id            | String  | ID of the linked page (when `link_type` is 'page').                                   |

### collection\_item

This setting type lets editors pick a record from any ActiveRecord model in your Rails app. For example, on an e-commerce site, a `featured_product_01` section often uses a `collection_item` setting so editors can choose a product from the `products` table.

**Definition:**

| Option         | Type   | Description                                                 |
| -------------- | ------ | ----------------------------------------------------------- |
| collection\_id | String | <p>Collection id as declared in <code>theme.yml</code></p> |

{% code title="app/theme/sections/sample.yml" %}
```yaml
settings:
- label: "Product"
  id: product
  type: collection_item
  collection_id: products

```
{% endcode %}

**Usage in the HTML/ERB template:**

{% tabs %}
{% tab title="Template" %}
{% code title="app/views/theme/sections/sample.html.erb" %}
```markup
<%= maglev_section.setting_tag :product, class: 'featured-product' do |product| %>
  <h2><%= product.name %></h2>
  <p><%= number_to_currency product.price %></p>
<% end %>
```
{% endcode %}
{% endtab %}

{% tab title="Raw template" %}
{% code title="app/views/theme/sections/sample.html.erb" %}
```markup
<% if maglev_section.settings.product.exists? %>
  <div class="featured-product" <%= maglev_section.settings.product.dom_data %>>
    <h2><%= maglev_section.settings.product.item.name %></h2>
    <p><%= number_to_currency maglev_section.settings.product.item.price %></p>
  </div>
<% end %>
```
{% endcode %}
{% endtab %}
{% endtabs %}

{% hint style="warning" %}
If the editor has not chosen an item, or the record no longer exists, the setting tag is not rendered.
{% endhint %}

**List of properties:**

| Property | Type    | Description                               |
| -------- | ------- | ----------------------------------------- |
| exists?  | Boolean | True if the collection item exists in DB. |
| item     | Model   | The collection item loaded from the DB.   |

### color

Display a color picker. The content editor will have to choose between a selection of color presets defined by the developer.

**Definition:**

| Option  | Type             | Description                 |
| ------- | ---------------- | --------------------------- |
| presets | Array of strings | List of hexadecimal colors. |

{% code title="app/theme/sections/sample.yml" %}
```yaml
settings:
- label: "Background color"
  id: background_color
  type: color
  presets: ["#F87171", "#FBBF24", "#34D399"]
  default: "#F87171"
```
{% endcode %}

**Usage in the HTML/ERB template:**

{% code title="app/views/theme/sections/sample.html.erb" %}
```markup
<div class="banner" style="background-color: <%= section.settings.background_color %>">
  <h2>Hello world</h2>
</div>
```
{% endcode %}

**List of properties:**

| **Property** | Type    | Description                                                     |
| ------------ | ------- | --------------------------------------------------------------- |
| dark?        | Boolean | True if the `brightness` index of this color is less than 128.  |
| light?       | Boolean | True if the `brightness` index of this color is greater than 155. |
| brightness   | Integer | Value between 0 and 255.                                        |

### checkbox

Display a toggle input.

**Definition:**

{% code title="app/theme/sections/sample.yml" %}
```yaml
settings:
- label: "Display warning message?"
  id: display_warning_message
  type: checkbox
  default: false
```
{% endcode %}

**Usage in the HTML/ERB template:**

{% code title="app/views/theme/sections/sample.html.erb" %}
```erb
<% if section.settings.display_warning_message.true? %>
  <div>My warning message</div>
<% end %>
```
{% endcode %}

{% hint style="warning" %}
Don't write `<% if section.settings.display_warning_message %>`

since the condition will always be true. Instead, use `true?` or `false?`.
{% endhint %}

**List of properties:**

| **Property** | Type    | Description |
| ------------ | ------- | ----------- |
| true?        | Boolean |             |
| false?       | Boolean |             |

### icon

Display a popup to select an icon among a set of icons. Follow the [instructions here](../guides/use-an-icon-library) to set up the icon library.

**Definition:**

{% code title="app/theme/sections/sample.yml" %}
```yaml
settings:
- label: "Icon"
  id: cta_icon
  type: icon
  default: 'fa fa-github'
```
{% endcode %}

**Usage in the HTML/ERB template:**

```erb
<div>
  <%= maglev_section.setting_tag :icon, html_tag: 'i' %>
</div>
```

### select

Display an HTML select field to let the editor pick one of the options defined in the section definition.

#### Definition:

{% code title="app/theme/sections/sample.yml" %}
```yaml
settings:
- label: "Animation on scroll"
  id: aos_class
  type: select
  select_options:
  - label: Fade
    value: fade-up
  - label: Flip
    value: flip-left
  - label: Zoom
    value: zoom-in
  default: fade-up
```
{% endcode %}

#### Advanced examples:

**Simple select with basic options:**

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

{% hint style="info" %}
**Localization**: For multi-language support, use the translation files as described in the [Translating select options](#translating-select-options) section below.
{% endhint %}

#### Usage in the HTML/ERB template:

```erb
<div class="<%= section.settings.aos_class %>">
   My amazing content
</div>
```

### hint

Shows informational text in the section editing form—for example, tips for content editors.

{% hint style="info" %}
**It is not intended to be displayed.**
{% endhint %}

#### Definition:

{% code title="app/theme/sections/sample.yml" %}
```yaml
settings:
- label: "This text will be displayed in the editor UI"
  id: some_hint
  type: hint
```
{% endcode %}

### divider

Display a line between two adjacent settings in the editor UI. The label can be shown if the `with_hint` option is enabled.

{% hint style="info" %}
**It is not intended to be displayed.**
{% endhint %}

#### Definition:

{% code title="app/theme/sections/sample.yml" %}
```yaml
settings:
- label: "This text will be displayed in the editor UI"
  id: a_divider_and_hint
  type: divider
  with_hint: true
```
{% endcode %}

***

## Translating setting labels

While the `label` property defines the default text displayed in the editor UI, you can translate these labels by adding translations to your main application's locale files. The translations follow a specific naming convention under the `maglev.themes` namespace.

### Translation structure

In your Rails application, add translations in your locale files (`config/locales/[locale].yml`) using this structure:

```yaml
en:
  maglev:
    themes:
      [theme_name]:
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
        sections:
          showcase:
            settings:
              title: "Title 😎"
```

The system will automatically use these translations in the editor interface when displaying setting labels. If no translation is found, it will fall back to the `label` value defined in the section's YAML file.

### Translating select options

For `select` type settings, you can translate both the setting label and the individual option labels. The option translations use a specific structure where all options for a setting are grouped under `{setting_id}_options`:

```yaml
en:
  maglev:
    themes:
      [theme_name]:
        sections:
          [section_name]:
            settings:
              [setting_id]: "Translated Setting Label"
              [setting_id]_options:
                [option_value]: "Translated Option Label"
```

### Select translation example

Given this select setting definition:

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

The system will automatically use these translations in the editor interface when displaying both the setting label and the option labels. If no translation is found, it will fall back to the `label` values defined in the section's YAML file.
