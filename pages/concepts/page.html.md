---
title: Page
order: 4
---

# Page

A page belongs to a site. It carries the content of the section.

### Attributes

| Name              | Type             | Description                                                                      |
| ----------------- | ---------------- | -------------------------------------------------------------------------------- |
| title             | string           | Title of the page. Displayed in the editor UI.                                   |
| path              | string           | Path of the page. 2 pages can't have the same path.                              |
| seo\_title        | string           | Used for SEO purpose.                                                            |
| meta\_description | string           | User for SEO purpose.                                                            |
| visible           | boolean          | True if the content editor wants the page to be public and visible by everybody. |
| sections          | list of sections | Content of the page.                                                             |
