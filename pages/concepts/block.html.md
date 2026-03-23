---
title: Block
order: 7
---

# Block

A `section` references a list of `block` types.

{% hint style="info" %}
A section might define **no** block types.
{% endhint %}

Here are some examples of when block types are useful:

* a **header** section will need a **menu\_item** block type to describe the top menu.
* a **carousel** section will need different **vignette** block types if it wants to display a list of mixed image and video vignettes.
* a **faq** section will need a **question\_answer** block type to list all the questions and their answers.

By default, blocks appear in the editor as a **list** that editors can reorder.\
But in some cases a list is too restrictive and a **tree** layout fits better. Set **`blocks_presentation`** to **`tree`** in the section definition (see the [Section](/concepts/section) page).

## Definition file

Block types are declared in the parent section’s YAML file under the `blocks` attribute.

| Attribute name | Type              | Description                                                                                                                 |
| -------------- | ----------------- | --------------------------------------------------------------------------------------------------------------------------- |
| name           | string            | Name of the block (displayed in the editor UI)                                                                              |
| type           | string            | Identifier of the block (useful in the template when differentiating block types within a section).         |
| settings       | array of settings | Work the same as in the section definition.                                                                                 |
| accept         | array of strings  | If `blocks_presentation` is set to `tree`, a block can accept several other block types. |

## Template

You can iterate through the list of blocks of your section.

Each Maglev block exposes a few attributes and methods.

| Attribute / Method | Type    | Description                                                                                                                                                                                   |
| ------------------ | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| wrapper\_tag       |         | <p>Display the wrapping HTML tag with </p><p>the information required by the editor UI.</p><p>To use a tag other than DIV, you can write:</p><p><code>maglev_block.wrapper_tag.li</code> </p> |
| setting\_tag       |         | <p>Display the setting of a block. The first argument is</p><p>the id of your setting.</p>                                                                                                    |
| block\_type        | String  | Type of the block                                                                                                                                                                             |
| children?          | Boolean | <p>True if the block has children AND the <code>block_display</code></p><p>attribute has been set to <strong>tree</strong> in the section definition.</p>                                     |
| children           | Array   | List of blocks                                                                                                                                                                                |

```markup
<nav>
  <ul>
    <% maglev_section.blocks.each do |maglev_block| %>
      <%= maglev_block.wrapper_tag.li do %>
        <%= maglev_block.setting_tag :link do %>
          <%= maglev_block.setting_tag :label %>
        <% end %>
      <% end %>
    <% end %>
  </ul>
</nav>
```

You can also skip our helpers and write your code in a more plain HTML approach.

As with section templates, you must mark up the DOM so the editor recognizes each block. Add `<%= maglev_block.dom_data %>` on the HTML element that wraps the block.

```markup
<nav>
  <ul>
    <% maglev_section.blocks.each_with_index do |maglev_block, index| %>
      <li <%= maglev_block.dom_data %>>
        <a href="<%= maglev_block.settings.link.href %>" <% if maglev_block.settings.link.open_new_window? %>target="_blank"<% end %>>
          <span <%= maglev_block.settings.label.dom_data %> ><%= maglev_block.settings.label %></span>
        </a>
      </li>
    <% end %>
  </ul>
</nav>
```

## Template with block children

{% code title="navbar_01.html.erb" %}
```markup
<%= maglev_section.wrapper_tag class: 'navbar' do %>
  <%= maglev_section.setting_tag :logo, class: 'brand-logo' %>
  <nav>
    <ul>
      <% maglev_section.blocks.each do |maglev_block| %>
        <%= maglev_block.wrapper_tag.li class: 'navbar-item' do %>
          <%= maglev_block.setting_tag :link do %>
            <%= maglev_block.setting_tag :label, html_tag: :span %>
          <% end %>
          <% if maglev_block.children? %>
            <ul>
              <% maglev_block.children.each do |nested_maglev_block| %>
                <%= nested_maglev_block.wrapper_tag.li class: 'navbar-nested-item' do %>
                  <%= nested_maglev_block.setting_tag :link do %>
                    <%= nested_maglev_block.setting_tag :label, html_tag: :span %>
                  <% end %>
                <% end %>
              <% end %>
            </ul>
          <% end %>
        <% end %>
      <% end %>
    </ul>
  </nav>
<% end %>
```
{% endcode %}
