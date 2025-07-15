---
title: Setup collections
order: 2
---

# Setup collections

Collections in Maglev are a powerful feature to expose the content of your Ruby on Rails application within the Maglev CMS. \
In other words, thanks to this functionality, your **ActiveRecord** models can be used in an editorial way in the Maglev editor UI.

Here a quick example: \
\
Let's assume you built a RoR e-commerce site with a **products** collection. Now, your client is asking you for a way to display the product of the month on the home page. This product is an editor choice and it can't fetched from a magic SQL query.\
And, of course, the client wants to use the fancy Maglev Editor UI to pick her product when editing the home page of her site.\
We built the **collections** feature for this exact use case.

{% hint style="info" %}
We could also have built within Maglev a content type builder like what [Strapi](https://strapi.io) offers but we believe that **Rails** in combination with [ActiveAdmin](https://activeadmin.info) or [Avo](https://avohq.io) does a more reliable job in the long run. Besides Maglev only targets the visual editing part of a CMS.
{% endhint %}

### Define collections

Maglev requires a mapping object defined in its config file to expose the ActiveRecord models that will be used by the Maglev sections.

Maglev requires at least 2 pieces of information for each collection:

* **model** which is the name of the ActiveRecord class
* **fields** which describes how to get the label and/or the image from a record

In order to display the list of choices in the CollectionItem component, Maglev needs a **label** and/or an **image** (optional) for each item.

![An editor selecting a product](https://1311630049-files.gitbook.io/~/files/v0/b/gitbook-legacy-files/o/assets%2F-Me54MJUO0o8Vj5WCTWJ%2F-MhojRC27bDGhRCUzhDL%2F-MhokhmvoCILFS041o7A%2FScreen%20Shot%202021-08-23%20at%2010.45.10%20PM.png?alt=media\&token=46588c01-0fe8-4111-9f87-feba5af74e63)

{% code title="config/initializer/maglev.rb" %}
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
The image alias pointing to a method of the model class **MUST** return a **permanent url**. So, if you use ActiveStorage, we recommend you to [follow this guide here](https://edgeguides.rubyonrails.org/active_storage_overview.html#putting-a-cdn-in-front-of-active-storage) and implement something like the following in your model:

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
{% endhint %}

### Handle custom DB query

By default, the **collections** feature will perform a simple SQL query to fetch the items for the Maglev editor UI component. \
\
But sometimes, we'll need a more complex query.

Back to our last example, the client might not want to see sold out products in the CollectionItem component. In that case, we need to inform Maglev that it will have to call a custom class method to fetch those items.

This custom class method expects **3 named parameters**:

* `site`: the instance of the Maglev site
* `keyword`: the text typed by the editor to filter the results
* `max_items`: the number of items which has to returned by the method

{% code title="config/initializer/maglev.rb" %}
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

And within your **Product** class, you will have to declare your `maglev_fetch_without_sold_out` method like this:

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

### Use collections in sections

Please visit the documentation [here](https://docs.maglev.dev/concepts/setting#collection_item).
