---
title: CLI Commands
order: 6
---

# CLI Commands

Maglev provides several Rails commands to help you manage your site, sections, and locales from the command line. These commands are designed to make common administrative tasks easier and more efficient.

## Site Management Commands

### Create a Site

Creates a new Maglev site with the first available theme.

```bash
bin/rails maglev:create_site
```

**What it does:**
- Checks if a site already exists
- Creates a new site using the first available local theme
- Provides feedback on success or if a site already exists

**Example output:**
```
🎉 Your site has been created with success!
```

**Error case:**
```
🤔 You already have a site. 🤔
```

### Change Site Locales

Updates the locales configuration for your site. This is useful for setting up multilingual sites.

```bash
bin/rails maglev:change_site_locales [label:prefix label2:prefix2 ...]
```

**Parameters:**
- `label`: The display name for the locale (e.g., "English", "Français")
- `prefix`: The URL prefix for the locale (e.g., "en", "fr", "" for default)

**Examples:**

Set up English and French locales:
```bash
bin/rails maglev:change_site_locales "English:en" "Français:fr"
```

Set up a single locale with no prefix (default):
```bash
bin/rails maglev:change_site_locales "English:"
```

**What it does:**
- Validates the locale format (must be `label:prefix`)
- Updates the site's locale configuration
- Provides feedback on success or validation errors

**Example output:**
```
Success! 🎉🎉🎉
```

**Error cases:**
```
[Error] You don't seem to have an existing site. 🤔
[Error] make sure your locales follow the 'label:prefix' pattern. 🤓
```

## Section Management Commands

### Reset Section Content

Resets the content of all sections of a specific type across your site and pages.

```bash
bin/rails maglev:sections:reset TYPE
```

**Parameters:**
- `TYPE`: The section type to reset (e.g., "hero", "features", "contact")

**Example:**
```bash
bin/rails maglev:sections:reset hero
```

**What it does:**
- Finds all sections of the specified type across the site and pages
- Resets their content to default values
- Provides a count of affected sections

**Example output:**
```
Successfully reset content of 3 sections of type 'hero' 🎉
```

**Error cases:**
```
[Error] You don't seem to have an existing site. 🤔
[Error] No theme found. 🤔
No section of type 'hero' found 🤔
```

### Rename Section Type

Renames all sections of a specific type across your site and pages.

```bash
bin/rails maglev:sections:rename OLD_TYPE NEW_TYPE
```

**Parameters:**
- `OLD_TYPE`: The current section type name
- `NEW_TYPE`: The new section type name

**Example:**
```bash
bin/rails maglev:sections:rename hero main_hero
```

**What it does:**
- Finds all sections of the old type
- Updates them to use the new type name
- Maintains all existing content and settings

**Example output:**
```
Successfully renamed all 'hero' sections to 'main_hero' 🎉
```

**Error cases:**
```
[Error] You don't seem to have an existing site. 🤔
[Error] No theme found. 🤔
```

### Remove Section Type

Removes all sections of a specific type from your site and pages.

```bash
bin/rails maglev:sections:remove TYPE
```

**Parameters:**
- `TYPE`: The section type to remove

**Example:**
```bash
bin/rails maglev:sections:remove old_banner
```

**What it does:**
- Finds all sections of the specified type
- Removes them from the site and all pages
- Provides a count of removed sections

**Example output:**
```
Successfully removed 2 sections of type 'old_banner' 🎉
```

**Error cases:**
```
[Error] You don't seem to have an existing site. 🤔
No section of type 'old_banner' found 🤔
```

## Common Use Cases

### Setting Up a New Multilingual Site

1. Create the site:
```bash
bin/rails maglev:create_site
```

2. Configure locales:
```bash
bin/rails maglev:change_site_locales "English:" "Français:fr" "Español:es"
```

### Managing Section Types During Development

When you're developing and need to update section types:

1. Rename a section type:
```bash
bin/rails maglev:sections:rename old_hero new_hero
```

2. Reset content if needed:
```bash
bin/rails maglev:sections:reset new_hero
```

3. Remove deprecated sections:
```bash
bin/rails maglev:sections:remove deprecated_banner
```

## Troubleshooting

### Common Issues

**"You don't seem to have an existing site"**
- Make sure you've run `bin/rails maglev:create_site` first
- Check that your database is properly set up

**"No theme found"**
- Ensure you have at least one theme in your `app/theme/` directory
- Check that your theme files are properly formatted

**"No section of type found"**
- Verify the section type name is correct (case-sensitive)
- Check that sections of this type actually exist in your site

### Getting Help

All commands support the `--help` flag for additional information:

```bash
bin/rails maglev:create_site --help
bin/rails maglev:change_site_locales --help
bin/rails maglev:sections:reset --help
bin/rails maglev:sections:rename --help
bin/rails maglev:sections:remove --help
```

{% hint style="info" %}
These commands are designed to be safe and provide clear feedback. They won't make destructive changes without confirmation or clear indication of what will be affected.
{% endhint %} 