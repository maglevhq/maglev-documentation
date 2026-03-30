---
title: Section thumbnail
order: 1.5
---

# Section thumbnail

In the Maglev editor, the **section picker** can show a small preview image for each section so editors recognize layouts at a glance. That image is a **thumbnail** (often called a “screenshot” in older docs): a static JPEG served from your app, not a live render of the section.

## Where Maglev looks for the file

Maglev resolves the thumbnail URL from the section’s **category** and **id** (the base name of the section definition file). It expects a JPEG at this path inside your Rails app:

```text
public/theme/<category>/<section_id>.jpg
```

So the public URL is:

```text
/theme/<category>/<section_id>.jpg
```

**Example:** for `app/theme/sections/heroes/hero_01.yml` with `category: heroes` and id `hero_01`, add:

```text
public/theme/heroes/hero_01.jpg
```

Nested folders under `app/theme/sections/` only affect where the YAML and ERB live; the **id** is still the filename without `.yml`, and the **category** comes from the definition.

{% hint style="info" %}
If you use a CDN or `config.asset_host`, thumbnail URLs follow your **Rails application** asset host (same as other files under `public/`), not Maglev’s engine `asset_host`. See [Setup CDN](/guides/setup-cdn).
{% endhint %}

## Maglev v3: no automatic capture

Earlier Maglev setups that used the **theme admin** (for example alongside [Avo](/integrations/avo)) could open a section preview and use a **Take Screenshot** action to write that JPEG for you.

**Maglev v3 does not ship that admin UI.** There is no built-in button or headless job in the core gem to generate thumbnails from the rendered section.

So in v3 you typically:

1. **Render the section with representative content** — use the [`sample`](/guides/create-a-new-section#provide-sample-content) block in the section YAML so the layout looks right in the editor or on a preview page.
2. **Capture the frame** — browser screenshot, design export, or any tool you prefer; crop to match how you want the picker to look.
3. **Save as JPEG** with the exact path and filename above (`<section_id>.jpg`, under the correct category folder).

Re-run step 2–3 when the section’s visual design changes enough that the old thumbnail is misleading.

## Optional automation

If you want **one-click or CI-generated** thumbnails again, that belongs outside core Maglev v3 — for example a **custom rake task**, **Playwright** script, or a **separate plugin** that renders the section and writes `public/theme/...jpg`. Core stays responsible only for **serving** the file at the conventional path.

## See also

* [Create a new section](/guides/create-a-new-section) — generator, templates, and `sample` content
* [Upgrades](/guides/upgrades) — v2 to v3, including editor and admin changes
