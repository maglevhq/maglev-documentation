---
title: Block
order: 7
---

# Block

A `section` references a list of `block` types.

{% hint style="info" %}
A section might have no section in its definition.
{% endhint %}

Here are some examples when having block types is useful: 

* a **header** section will need a **menu\_item** block type to describe the top menu. 
* a **carousel** section will need different **vignette** block types if it wants to display a list of mixed image and video vignettes.
* a **faq** section will need a **question\_answer** block type to list all the questions and their answers.

By default, in the editor UI, the instance of blocks are displayed as a list which can be re-ordered.\
But in some case, a list will be too restrictive and a tree representation will be more appropriate. So, you will have to set the `block_display`  attribute to **true** in the section definition.

### Definition file

Block types are declared in the same file as its parent section under the `blocks` attribute.

| Attribute name | Type              | Description                                                                                                                 |
| -------------- | ----------------- | --------------------------------------------------------------------------------------------------------------------------- |
| name           | string            | Name of the block (displayed in the editor UI)                                                                              |
| type           | string            | Identifier of the block (useful in the template when differenciating the different kind of blocks among a section).         |
| settings       | array of settings | Work the same as in the section definition.                                                                                 |
| accept         | array of strings  | If the `blocks_presentation` option has been set to `tree`, a block can decide to accept several kind of other block types. |

### Template

You can iterate through the list of blocks of your section. 

Each maglev block owns a couple of attributes / methods. 

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

The same way we do in the `section` template,  you've to instruct the editor UI that a block is being displayed. To achieve it, you have to put `<%= block.dom_data %>` in the HTML node tag wrapping your block.

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

### Template with block children

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
