---
title: Create a new section
order: 1
---

# Create a new section

This guide helps you to create a maglev section and integrates it in the editor UI.

## Generate the section files

The **maglev** gem offers a Rails generator to quickly generate the files required by a maglev section.

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

Here is an example of a section with one single type of block

```bash
> bundle exec rails g maglev:section showcase_01 \
--category=showcase \
--settings \
title:text overall_description:text \
block:project:name:text block:project:screenshot:image
```

## Code the section

Once the different files of the section have been generated, it's time to complete the definition and template files.

Start by visiting the [admin url](http://localhost:3000/maglev/admin/theme) once you've started your Rails server and click to the title of your newly generated section. You will see a screen like this one.

![Maglev admin page](https://1311630049-files.gitbook.io/~/files/v0/b/gitbook-legacy-files/o/assets%2F-Me54MJUO0o8Vj5WCTWJ%2F-MgfTUQsayPcc00o3-2T%2F-MgfUAh4wJk8iZsZNHV1%2FScreen%20Shot%202021-08-09%20at%205.15.29%20PM.png?alt=media\&token=47897669-8a99-4741-8609-690d409be854)

There are 3 different buttons on this screen:

* **Open editor**: it opens the Editor UI
* **Open in a new tab**: it opens the section in a new tab without the maglev admin layout. Very useful when coding the template of the section.
* **Take screenshot**: once your section looks good (please visit the next sub chapter before) , it's time to take a screenshot of it for the editor UI. It will be displayed in the list of sections available for the editors.

## Provide a sample content

Providing a sample content for a section is helpful in 3 main cases:

* when writing the template of the section with "real" content.
* when generating a screenshot of the section with "real" content".
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
