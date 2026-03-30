---
title: Introduction
order: 1
---

# Introduction

The **Maglev SaaS plugin** (`maglevcms-saas-plugin`) extends [Maglev core](https://github.com/maglevhq/maglev-core) so you can run a **multi-site, multi-theme** page-builder platform inside your own Rails application—the same model as the legacy **Maglev PRO** gem, built for **Maglev v3**.

{% hint style="info" %}
**Live reference**

- Demo: [demo-pro.maglev.dev](https://demo-pro.maglev.dev)
- Reference application (Rails + Maglev core + SaaS plugin): [maglevhq/site-builder-demo](https://github.com/maglevhq/site-builder-demo)
- [Pricing](https://www.maglev.dev/saas-edition/#pricing)
  {% endhint %}

The open source Maglev gem targets a **single site** per app. The SaaS plugin removes that limit: signed-in users can create and manage many sites, pick from the themes you ship, and edit content in the Maglev editor.

Typical use cases:

- **Franchisors** — give each location its own site from one Rails app.
- **Agencies** — spin up microsites or campaign landings without a separate CMS product.
- **SaaS products** — offer a site builder as part of your platform, on your infrastructure.

If you are still on **Maglev v2** with the **Maglev PRO** gem, see [Pro](https://v2.docs.maglev.dev/pro/introduction) for that edition; new multi-site work on v3 belongs with the SaaS plugin and the guides below.
