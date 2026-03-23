---
title: Render a section outside the Maglev layout
order: 9
---

# Render a section outside the Maglev layout

{% hint style="info" %}
This guide mainly targets the users of the **MIT version**.
{% endhint %}

Some pages are **not** fully managed in the Maglev editor—for example, a Rails **product detail** template that still needs your **navbar** and **footer** from Maglev.

For that, the engine provides a controller concern so you can **`render_maglev_section`** outside the Maglev theme layout.

**Content for those sections is still edited in the Maglev editor** (for example as site-scoped navbar/footer blocks). The standalone template only **renders** the current published output.

## Inside your Rails controller

{% hint style="warning" %}
Sections must be **`site_scoped`** to load this way. See [Section definition](/concepts/section#definition-file).
{% endhint %}

Include the engine’s **`Maglev::StandaloneSectionsConcern`** in the controller that serves the page (or in `ApplicationController`).

Example for a product page:

{% code title="app/controllers/products_controller.rb" %}
```ruby
class ProductsController < ApplicationController
  include Maglev::StandaloneSectionsConcern # methods required to load site-scoped sections

  def show
    fetch_maglev_site_scoped_sections # loads all site-scoped sections for this request
    @product = Product.find(params[:id])
  end
end

```
{% endcode %}

To load site-scoped sections on **every** request:

{% code title="app/controllers/application_controller.rb" %}
```ruby
class ApplicationController < ActionController::Base
  include Maglev::StandaloneSectionsConcern # methods required to load site-scoped sections

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
If you include the concern in `ApplicationController`, you will usually render shared chrome (navbar, footer) from `app/views/layouts/application.html.erb` so every page gets it.
{% endhint %}
