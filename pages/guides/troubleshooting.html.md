---
title: Troubleshooting
order: 10
---

# Troubleshooting

{% hint style="info" %}
We suggest you first search for your error message in the [project issues on Github](https://github.com/maglevhq/maglev-core/issues).
{% endhint %}

## I can't get into the editor, I see errors related to Vite in my logs

There's a chance that **Vite-ruby** wasn't installed, or that errors occurred during the installation process.

First, make sure you have `yarn` installed on your machine. Then, re-run these two steps of the installation procedure:

```bash
bundle exec rails maglev:vite:install_dependencies
bundle exec rails maglev:vite:build_all
```

***

## In my terminal, I see the following error:

```
Building with Vite ⚡️
Usage Error: Couldn't find the node_modules state file - running an install might help (findPackageLocation)
```

The Maglev editor UI is a VueJS application and therefore it requires a couple of Javascript libraries to be built by Vite. Those Javascript libraries seems to not be installed. \
\
To install them, type:

```bash
bundle exec rails maglev:vite:install_dependencies
```

***

## I'v upgraded my Ruby version and I see errors related to Vite in my logs

```
Vite Ruby can't find entrypoints/editor.js in the manifests.
```

You need to re-generate the Maglev editor UI assets with the following commands:

```bash
bundle exec rails maglev:vite:install_dependencies
bundle exec rails maglev:vite:build_all
```
