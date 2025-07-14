# Gitbook to Sitepress Migration Guide

This repository contains a complete Sitepress documentation site with custom ViewComponents designed to help you migrate from Gitbook to Sitepress.

## What's Included

### ViewComponents
All documentation pages use these reusable components for consistent styling:

- **`Docs::LayoutComponent`** - Page wrapper with title and breadcrumbs
- **`Docs::SectionComponent`** - Content grouping with anchor links
- **`Docs::CardComponent`** - Informative blocks with optional icons
- **`Docs::CalloutComponent`** - Tips, notes, and warnings (info, tip, warning variants)
- **`Docs::CodeBlockComponent`** - Syntax-highlighted code blocks
- **`Docs::StepComponent`** - Step-by-step tutorials
- **`Docs::TableComponent`** - Structured data display

### Sample Pages
- **`/`** - Main documentation homepage
- **`/getting-started`** - Example documentation page
- **`/migration-guide`** - This migration guide

### Migration Tools
- **`scripts/migrate_gitbook.rb`** - Automated migration script

## Quick Start

1. **Install dependencies:**
   ```bash
   bundle install
   yarn install
   ```

2. **Start the development server:**
   ```bash
   sitepress server
   ```

3. **View the site:**
   Open http://127.0.0.1:8080

## Migration Process

### Step 1: Export from Gitbook

**Option A: Export from Gitbook UI**
1. Go to your Gitbook space
2. Navigate to **Settings** → **Export**
3. Choose **PDF** or **HTML** format
4. Download the exported files

**Option B: Use Gitbook Repository (Recommended)**
If you have access to your Gitbook repository, copy the markdown files directly from the `docs/` directory.

### Step 2: Run the Migration Script

```bash
# Make the script executable (if not already)
chmod +x scripts/migrate_gitbook.rb

# Run the migration
ruby scripts/migrate_gitbook.rb -i /path/to/gitbook/md -o ./pages
```

**Example:**
```bash
ruby scripts/migrate_gitbook.rb -i ./gitbook-export -o ./pages
```

### Step 3: Manual Adjustments

The migration script handles basic conversions, but you'll need to:

1. **Review converted files** - Check the generated `.html.erb` files
2. **Add step content** - The script creates step components but you need to add the actual content
3. **Fix internal links** - Update any `{% page-ref %}` references to regular markdown links
4. **Customize styling** - Adjust component usage to match your needs

### Step 4: Test and Deploy

1. **Test locally:**
   ```bash
   sitepress server
   ```

2. **Build for production:**
   ```bash
   sitepress compile
   ```

3. **Deploy** the `./build` directory to your hosting provider

## Gitbook to Sitepress Syntax Mapping

| Gitbook Syntax | Sitepress Component | Example |
|---|---|---|
| `{% hint style="info" %}` | `Docs::CalloutComponent` | See migration guide |
| `{% code-tabs %}` | `Docs::CodeBlockComponent` | See migration guide |
| `{% embed %}` | Custom component or iframe | Manual conversion needed |
| `{% page-ref %}` | Regular markdown links | `[Link Text](/path)` |
| Numbered lists | `Docs::StepComponent` | See migration guide |

## File Organization

Organize your migrated content in the `pages/` directory:

```
pages/
├── index.html.erb                    # Homepage
├── getting-started.html.erb          # Getting started guide
├── api/
│   ├── index.html.erb               # API overview
│   ├── authentication.html.erb      # Auth documentation
│   └── endpoints.html.erb           # API endpoints
├── guides/
│   ├── installation.html.erb        # Installation guide
│   └── configuration.html.erb       # Configuration guide
└── reference/
    ├── cli.html.erb                 # CLI reference
    └── config.html.erb              # Config reference
```

## Customization

### Adding New Components

1. Create the component class in `components/docs/`
2. Create the template in `components/docs/`
3. Use in your pages with `<%= render Docs::YourComponent.new %>`

### Styling

The site uses TailwindCSS for styling. All components use utility classes for consistent design.

### Icons

Font Awesome is included for icons. Use classes like `fas fa-info-circle` in components.

## Troubleshooting

### Common Issues

1. **Component not found** - Make sure the component file exists in `components/docs/`
2. **Styling not applied** - Check that TailwindCSS is properly configured
3. **Icons not showing** - Verify Font Awesome is loaded

### Getting Help

- Check the [Sitepress documentation](https://sitepress.cc)
- Review the sample pages in this repository
- Look at the ViewComponent templates for examples

## Next Steps

After migration:

1. **Customize the design** - Modify component templates to match your brand
2. **Add search functionality** - Consider adding a search component
3. **Set up analytics** - Add tracking to monitor usage
4. **Configure deployment** - Set up CI/CD for automatic builds

## Support

This migration setup is designed to be self-contained. All the tools and examples you need are included in this repository.

For Sitepress-specific questions, visit [sitepress.cc](https://sitepress.cc). 