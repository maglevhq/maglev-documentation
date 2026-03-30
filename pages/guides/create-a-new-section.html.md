---
title: Create a new section
order: 1
---

# Create a new section

This guide walks you through creating a **Maglev** section and using it in the editor.

## Generate the section files

The **Maglev** gem provides a Rails generator for the files a section needs.

The following command will generate a sample section with a few settings and blocks.

```bash
> bundle exec rails g maglev:section example
```

### Syntax

```bash
> bundle exec rails g maglev:section <ID of your section> \
--category=<CATEGORY> \
--settings \
<ID of the setting 1>:<TYPE> \
...
<ID of the setting N>:<TYPE> \
block:<TYPE>:<ID of setting 1>:<TYPE> \
...
block:<TYPE>:<ID of setting N>:<TYPE> \

```

### Example

Here is an example of a section with one block type

```bash
> bundle exec rails g maglev:section showcase_01 \
--category=showcase \
--settings \
title:text overall_description:text \
block:project:name:text block:project:screenshot:image
```

## Code the section

After the generator runs, finish the section by editing its **definition** (YAML) and **template** (ERB) on disk. There is **no separate theme admin** for this step—you change the files directly, then reload the **Maglev editor** to see updates.

Paths follow the section id you passed to the generator:

| File            | Path pattern                                      |
| --------------- | ------------------------------------------------- |
| Definition      | `app/theme/sections/<section_id>.yml`             |
| Section template | `app/views/theme/sections/<section_id>.html.erb` |

Examples matching the commands above:

* `rails g maglev:section example` → `app/theme/sections/example.yml` and `app/views/theme/sections/example.html.erb`
* `rails g maglev:section showcase_01 ...` → `app/theme/sections/showcase_01.yml` and `app/views/theme/sections/showcase_01.html.erb`

Use **`maglev_section`** (and **`maglev_block`** when you have blocks) in the ERB template to render settings and iterate blocks. Details and helpers are in the [Section](/concepts/section) and [Block](/concepts/block) concept pages.

When you are ready to try it in the UI, start the Rails server and open the editor (typically [http://localhost:3000/maglev/editor](http://localhost:3000/maglev/editor)), add the section to a page, and refresh after template changes.

## Provide sample content

Sample content helps in three situations:

* when writing the template of the section with "real" content.
* when capturing or designing the [section thumbnail](/guides/section-thumbnail) so the picker preview matches a realistic layout.
* when an editor picks the section in the editor UI. She won't see a blank section.

This can be achieved by declaring the **sample** attribute in the definition file of the section.

### Example:

{% code title="app/theme/sections/showcase_01.yml" %}
```yaml
name: showcase_01

...

settings:
....

blocks:
....

# By default, in the editor UI, blocks will be listed below the "Content" title.
# The title can be changed with the following property:
# blocks_label: "My list of items"

# By default, blocks are presented as a list in the editor UI.
# If you like to use blocks to build a menu with sub menu items,
# consider using the tree presentation
# blocks_presentation: "tree"

sample:
  settings:
    title: "Let's create the product<br/>your clients<br/>will love."
    image: "/maglev-placeholder.jpg"
  blocks:
    - type: list_item
      settings:
        title: "Item #1"
        image: "/maglev-placeholder.jpg"
    - type: list_item
      settings:
        title: "Item #2"
        image: "/maglev-placeholder.jpg"
    - type: list_item
      settings:
        title: "Item #3"
        image: "/maglev-placeholder.jpg"
    - type: list_item
      settings:
        title: "Item #4"
        image: "/maglev-placeholder.jpg"


```
{% endcode %}
