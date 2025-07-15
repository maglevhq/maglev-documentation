---
title: Render a section outside the Maglev layout
order: 7
---

# Render a section outside the Maglev layout

{% hint style="info" %}
This guide mainly targets the users of the **MIT version**.
{% endhint %}

When developing your Maglev site, it might happen that you will need pages that won't necessarily be  editable from the Maglev editor UI. \
\
For example, let's say you're deveveloping an e-commerce site and you are building the ERB template of the product detail page. \
Your product ERB template will certainly require 2 specific sections from your Maglev site: the navbar and the footer. 

In order to fill that requirement, the Maglev engine comes with a Rails controller concern allowing the developer to render a specific section outside the Maglev ERB layout.

**The content of those sections will only be editable from the Maglev pages only.**

## Inside your Rails controller

{% hint style="warning" %}
Your sections have to be **site scoped** to work outside the Maglev layout scope. See the documentation [here](https://docs.maglev.dev/concepts/section#definition-file) and here for more explanation.
{% endhint %}

You first have to enhance your Rails controller by adding our custom controller concern. 

The code below is based on the e-commerce site example we were talking about above.

{% code title="app/controllers/products_controller.rb" %}
```ruby
class ProductsController < ApplicationController
  include Maglev::StandaloneSectionsConcern # include all the methods require by Maglev to load and render site scoped sections

  def show
    fetch_maglev_site_scoped_sections # load the content of all the site scoped section
    @product = Product.find(params[:id])
  end
end

```
{% endcode %}

Another solution to have access to the site scoped sections across all your controllers would be:

{% code title="app/controllers/application_controller.rb" %}
```ruby
class ApplicationController < ActionController::Base
  include Maglev::StandaloneSectionsConcern # include all the methods require by Maglev to load and render site scoped sections

  before_action :fetch_maglev_site_scoped_sections
end
```
{% endcode %}

## Inside your ERB template

{% code title="app/views/products/show.html.erb" %}
```markup
<%= render_maglev_section :navbar %>

<div>
  <h1><%= @product.name %></h1>
  <p>Price: <%= number_to_currency @product.price %></p>
</div>

<%= render_maglev_section :footer %>
```
{% endcode %}

{% hint style="info" %}
If we have modified your `application_controller` file instead, we would have put the code in charge of rendering the navbar and footer in the `app/views/layouts/application.html.erb`.
{% endhint %}
