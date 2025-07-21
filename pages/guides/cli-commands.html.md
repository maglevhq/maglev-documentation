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

{% hint style="warning" %}
**Important: Data Backup Required**

Before running any of the section management commands below, we strongly recommend backing up your database and any important content. These commands can modify or remove data from your site and pages, and the changes may not be easily reversible.
{% endhint %}


### Reset Section Content

{% hint style="info" %}
**Available since Maglev 2.1**
{% endhint %}

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
