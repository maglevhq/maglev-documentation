---
title: Site
order: 2
---

# Site

The structure of a Maglev site and its child elements could be presented this way:

```
My company site (Site)
└── Home page (Page)
    ├── Header (Section)
    ├── Hero (Section)
    ├── Call to Action (Section)
    └── Features (Section)
        ├── Feature #1 (Block)
        ├── Feature #2 (Block)
        └── Feature #3 (Block)
├── Our team (Page)
└── Contact us (Page)
```

In another words:

* a site has many pages
* a page has many sections
* a section might have many blocks

## Attributes

| Name     | Type              | Description                                          |
| -------- | ----------------- | ---------------------------------------------------- |
| name     | string            | Name of the site.                                    |
| sections | array of sections | Global sections.                                     |
| domains  | array of string   | List of domains. **PRO version only.**               |
| handle   | string            | Unique identifier of the site. **PRO version only.** |
