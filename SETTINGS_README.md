# Global Settings System

This project uses a YAML-based global settings system that allows you to configure various aspects of your site from a single file.

## Configuration File

The main settings file is located at `config/settings.yml`. This file contains all the global settings for your site.

## How to Use Settings

### In Templates

You can access settings in your ERB templates using the `settings` helper:

```erb
<!-- Access nested settings -->
<h1><%= settings.site['title'] %></h1>
<p><%= settings.site['description'] %></p>

<!-- Access with dot notation -->
<h1><%= settings.get('site.title') %></h1>

<!-- Access entire sections -->
<% if settings.navigation['show_search'] %>
  <!-- Show search component -->
<% end %>

<!-- Conditional rendering based on settings -->
<% if settings.features['analytics_enabled'] %>
  <!-- Include analytics code -->
<% end %>
```

### In Ruby Code

You can also access settings in your Ruby components and helpers:

```ruby
# In a component or helper
site_title = Settings.site['title']
show_search = Settings.navigation['show_search']
primary_color = Settings.appearance['primary_color']
```

## Available Settings

### Site Information
- `site.title` - Site title
- `site.description` - Site description
- `site.author` - Site author
- `site.email` - Contact email
- `site.url` - Site URL

### Navigation
- `navigation.show_search` - Enable/disable search
- `navigation.show_breadcrumbs` - Show breadcrumb navigation
- `navigation.sidebar_collapsible` - Make sidebar collapsible
- `navigation.max_menu_depth` - Maximum depth for menu items

### Content
- `content.show_table_of_contents` - Show table of contents
- `content.toc_depth` - Depth of table of contents
- `content.show_edit_link` - Show edit page link
- `content.edit_link_text` - Text for edit link
- `content.show_last_updated` - Show last updated date
- `content.code_highlighting` - Enable code syntax highlighting
- `content.syntax_theme` - Code highlighting theme

### Appearance
- `appearance.theme` - Site theme (light/dark)
- `appearance.primary_color` - Primary color hex code
- `appearance.secondary_color` - Secondary color hex code
- `appearance.font_family` - Main font family
- `appearance.code_font_family` - Code font family

### Features
- `features.analytics_enabled` - Enable Google Analytics
- `features.comments_enabled` - Enable comments
- `features.search_enabled` - Enable search functionality
- `features.print_enabled` - Enable print styles
- `features.dark_mode_toggle` - Enable dark mode toggle

### Social Media
- `social.twitter` - Twitter handle
- `social.github` - GitHub username
- `social.linkedin` - LinkedIn profile

### SEO
- `seo.google_analytics_id` - Google Analytics ID
- `seo.google_tag_manager_id` - Google Tag Manager ID
- `seo.meta_description` - Default meta description
- `seo.meta_keywords` - Default meta keywords

## Adding New Settings

To add new settings:

1. Add them to `config/settings.yml`
2. Access them in your templates using `settings.your_section['your_setting']`
3. Use them in your components and layouts as needed

## Example Usage

### Conditional Features
```erb
<% if settings.features['search_enabled'] %>
  <div class="search-container">
    <!-- Search component -->
  </div>
<% end %>
```

### Dynamic Styling
```erb
<style>
  :root {
    --primary-color: <%= settings.appearance['primary_color'] %>;
    --font-family: <%= settings.appearance['font_family'] %>;
  }
</style>
```

### Analytics Integration
```erb
<% if settings.features['analytics_enabled'] && settings.seo['google_analytics_id'].present? %>
  <script async src="https://www.googletagmanager.com/gtag/js?id=<%= settings.seo['google_analytics_id'] %>"></script>
  <script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', '<%= settings.seo['google_analytics_id'] %>');
  </script>
<% end %>
```

## Testing Settings

Visit `/settings-example` to see all current settings displayed on a page. This is useful for verifying that your settings are being loaded correctly.

## Best Practices

1. **Use meaningful defaults** - Always provide sensible default values
2. **Group related settings** - Keep related settings in the same section
3. **Use boolean values** - For on/off features, use `true`/`false`
4. **Document new settings** - Add comments in the YAML file for clarity
5. **Test changes** - Always test your site after changing settings

## Environment-Specific Settings

You can create environment-specific settings files:
- `config/settings.yml` - Default settings
- `config/settings.production.yml` - Production-specific settings
- `config/settings.development.yml` - Development-specific settings

The system will automatically load the appropriate file based on your environment.
