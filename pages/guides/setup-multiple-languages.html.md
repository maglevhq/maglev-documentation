---
title: Setup multiple languages
order: 4
---

# Setup multiple languages

You can set up your site so that you can edit the content of your pages in different languages or locales.

## Installation

The installation of new locales is an easy job to do.

Open your `config/initializers/maglev.rb` file and start adding the following lines:

{% code title="config/initializers/maglev.rb" %}
```ruby
Maglev.configure do |config|
  ...
  config.default_site_locales = [
   { label: 'English', prefix: 'en' },
   { label: 'French', prefix: 'fr' }
  ]
  ...
end
```
{% endcode %}

Save this file and run the following command to apply those changes:

```shell
$ bundle exec rails maglev:change_site_locales
```

Finally, restart your Rails server.

Once it's done, go to the editor UI and you should see a locale picker like the one in the screenshot below.

![](pages/setup-multiple-languages-1.png)

### Locale switcher

A locale switcher is the UI component you usually see at the top of a localized site. It helps visitors to quickly change the locale of the current page. \
\
By default, Maglev isn't bundled with a plug-in-play locale switcher, mainly because the UI/UX of such component might vary a lot between sites.

Instead, Maglev provides the helpers required to build one.

Here is an example:

{% code title="app/views/theme/sections/navbar_01.html.erb" %}
```erb
<div>
    <% maglev_site.locales.each do |locale| %>
      <%= link_to t("lang.#{locale.prefix}"), maglev_alt_link(locale.prefix), class: { 'active': maglev_current_locale?(locale.prefix) } %>
    <% end %>
</div>

```
{% endcode %}



## Rules

The multi-languages functionality comes with several rules:

* the title, path, sections content and seo information attributes of a page can be translated.
* each translation of the page is independent. For instance, a page A in the **EN** locale can have **different sections** compared to its version in the **FR** locale.
* the default locale is the first locale of the site.
* when previewing a page in the default locale, the path of the page won't include the locale. Example: `mysite.com/about-us`
* when previewing a page in a local different from the default one, the page of the page will include the locale prefix. Example: `mysite.com/fr/a-notre-sujet`
