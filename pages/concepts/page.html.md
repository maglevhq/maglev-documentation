---
title: Page
order: 4
---

# Page

A page belongs to a site. It holds that page’s sections and their content.

## Attributes

| Name              | Type             | Description                                                                      |
| ----------------- | ---------------- | -------------------------------------------------------------------------------- |
| title             | string           | Title of the page. Displayed in the editor UI.                                   |
| path              | string           | URL path of the page. Two pages cannot share the same path.                              |
| seo\_title        | string           | Used for SEO.                                                            |
| meta\_description | string           | Used for SEO.                                                            |
| visible           | boolean          | True if the page should be public and visible to visitors. |
| sections          | list of sections | Content of the page.                                                             |
