---
title: Upgrades
order: 9
---

# Upgrades

## From v1 to v2

Nothing to do.

## From v1.0.x to v1.1.x

The layout of your theme must now include an additional Javascript file in the HTML header.\
This file is in charge of the communication between any page of the theme and the Maglev Editor UI.

```erb
<!DOCTYPE html>
<html>
<head>
  <title><%= maglev_page.seo_title.presence || maglev_site.name %></title>

  ....

  <%= maglev_live_preview_client_javascript_tag %>

  ....
```
