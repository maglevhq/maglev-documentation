# Maglev Documentation

This repository contains the documentation site for Maglev, structured for clarity, extensibility, and ease of contribution. It is built on top of Sitepress and leverages Rails conventions, but introduces a custom structure for documentation content, components, and assets.

## Project Structure

- **pages/**: Main documentation content, organized into:
  - `guides/`: Step-by-step guides and how-tos.
  - `concepts/`: Explanations of core concepts and data structures.
  - `pro/`: Pro features and advanced topics.
  - `integrations/`: Integration guides for third-party tools.
  - `index.html.md`: Main landing page for the docs.

- **components/**: View components for reusable UI elements.
  - `app_layout/`: Layout-related components (sidebar, topbar, navigation, etc.).
  - `app_layout_component.*`: Main layout component files.

- **assets/**: Static assets and frontend code.
  - `images/`: Logos, favicons, and documentation screenshots (with subfolder for page-specific images).
  - `stylesheets/`: CSS files, including Tailwind and code highlighting styles.
  - `javascripts/`: JavaScript files, including Stimulus controllers for interactive features.
  - `config/`: Asset pipeline configuration.

- **liquid/**: Custom Liquid tags and concerns for dynamic content rendering inherited from Gitbook
  - `tags/`: Custom tag implementations (e.g., code blocks, tabs, hints, descriptions).
  - `tags/concerns/`: Shared logic for tags.

- **layouts/**: HTML layout templates for the site.

- **helpers/**: Ruby helpers for view logic shared across pages and layouts.

- **config/**: Site configuration and initializers.

- **scripts/**: Ruby scripts for automation (e.g., generating markdown, search indexes, migrations).

- **spec/**: RSpec tests for custom tags and helpers.

## Getting Started

1. **Install dependencies:**
   - Ruby gems: `bundle install`
   - JavaScript packages: `yarn install`

```bash
gem install foreman
```

2. **Start the development server:**

   ```sh
   foreman start -f Procfile.dev
   ```

   Then open [http://127.0.0.1:8080](http://127.0.0.1:8080) to view the docs locally.

3. **Edit or add documentation:**
   - Add or update markdown files in `pages/`.
   - Add images to `assets/images/`.
   - Update or create components in `components/`.

4. **Compile for production:**
   ```sh
   bundle exec rake compile
   ```
   The static site will be built in the `./build` directory.

## Contributing

- Follow the established structure for new guides, concepts, or integrations.
- Use components for reusable UI.
- Use Stimulus controllers for JavaScript interactions.
- Prefer Tailwind CSS classes for styling.

## Deployment

The `publish` GitHub Action deploys static files to Bunny Storage via the HTTP Storage API using:

- `scripts/upload_to_bunny_storage.rb`

- `main` branch -> production docs target
- `v2` branch -> v2 docs target

Required GitHub secrets:

- Production (`main`):
  - `BUNNY_STORAGE_ZONE_NAME` (Storage zone name for upload)
  - `BUNNY_STORAGE_ZONE_PASSWORD` (Storage zone password used for uploads)
  - `BUNNY_ACCESS_KEY` (Bunny account API key used for pull-zone cache purge)
  - `SITE_BASE_URL`
  - `BUNNY_ZONE_ID` (Pull zone id for cache purge)
- V2 (`v2`):
  - `BUNNY_STORAGE_ZONE_NAME` (or set this in workflow to any v2-specific secret)
  - `BUNNY_STORAGE_ZONE_PASSWORD` (or set this in workflow to any v2-specific secret)
  - `BUNNY_ACCESS_KEY` (or set this in workflow to any v2-specific secret)
  - `SITE_BASE_URL_V2`
  - `BUNNY_ZONE_ID_V2`

Local upload command (same script as CI):

```bash
BUNNY_STORAGE_ZONE_NAME=... \
BUNNY_STORAGE_ZONE_PASSWORD=... \
bundle exec ruby ./scripts/upload_to_bunny_storage.rb ./build
```

## More Information

- For more on Sitepress, see [https://sitepress.cc](https://sitepress.cc)
- For Maglev documentation, browse this site or contribute via pull requests.
