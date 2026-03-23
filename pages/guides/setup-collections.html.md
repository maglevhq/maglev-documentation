---
title: Setup collections
order: 2
---

# Setup collections

**Collections** let you surface your Rails **ActiveRecord** models inside the Maglev editor—for example, so editors can pick a “product of the month” by hand instead of relying only on SQL.

Here’s a typical case: you run an e-commerce Rails app with a **`products`** collection. The client wants one featured product on the home page, chosen in the Maglev UI when they edit that page. Collections exist for that workflow.

{% hint style="info" %}
We could have built a content-type builder inside Maglev (similar to [Strapi](https://strapi.io)), but **Rails** plus tools like [ActiveAdmin](https://activeadmin.info) or [Avo](https://avohq.io) tends to scale better for structured data. Maglev focuses on the visual page-editing layer.
{% endhint %}

## Define collections

Declare collections in the Maglev initializer. Each entry needs at least:

- **`model`**: ActiveRecord class name (string)
- **`fields`**: how to read a **label** and optionally an **image** from each record

The editor picker needs at least a **label** for each row; **image** is optional but improves the UI.

![An editor selecting a product](pages/setup-collections-1.png)

{% code title="config/initializers/maglev.rb" %}

```ruby
Maglev.configure do |config|
  # ...
  config.collections = {
    products: {
      model: 'Product', # name of ActiveRecord class
      fields: {
        label: :name, # :name is the column name in the products table OR the name of the method.
        image: :thumbnail_url
      }
    },
    articles: {
      model: 'BlogPost',
      fields: {
        label: :title
      }
    }
  }
  # ...
end
```

{% endcode %}

{% hint style="info" %}
If you map **`image`** to a model method, that method **must** return a **stable, public URL** (for example via a CDN). With Active Storage, see the Rails guide on [putting a CDN in front of Active Storage](https://edgeguides.rubyonrails.org/active_storage_overview.html#putting-a-cdn-in-front-of-active-storage).
{% endhint %}

Example `thumbnail_url` helper (adjust to match your CDN helper name):

{% code title="app/models/product.rb" %}

```ruby
class Product < ApplicationRecord
  has_one_attached :thumbnail
  def thumbnail_url
    return nil unless thumbnail.attached?
    Rails.application.routes.url_helpers.cdn_image_url(
      thumbnail.variant(resize_to_limit: [200, 200])
    )
  end
end
```

{% endcode %}

## Custom database queries

By default, Maglev loads collection items with a simple query. For finer control (for example, hiding sold-out products), point the collection at a **custom class method** on the model.

That method must accept these **keyword arguments**:

- `site`: the instance of the Maglev site
- `keyword`: the text typed by the editor to filter the results
- `max_items`: maximum number of rows to return

{% code title="config/initializers/maglev.rb" %}

```ruby
Maglev.configure do |config|
  # ...
  config.collections = {
    products: {
      model: 'Product',
      fetch_method_name: :maglev_fetch_without_sold_out,
      fields: {
        label: :name,
        image: :thumbnail_url
      }
    },
    articles: {
      model: 'BlogPost',
      fields: {
        label: :title
      }
    }
  }
  # ...
end
```

{% endcode %}

On **`Product`**, implement the method like this:

{% code title="app/models/product.rb" %}

```ruby
class Product < ApplicationRecord
#...
  def self.maglev_fetch_without_sold_out(site:, keyword:, max_items: 10)
    all
      .where(sold_out: false)
      .where(keyword.present? ? Product.arel_table[:name].matches("%#{keyword}%") : nil)
      .limit(max_items)
      .order(:name)
  end
#...
end
```

{% endcode %}

## Use collections in sections

See the [`collection_item` setting](/concepts/setting#collection_item) in the concepts documentation.
