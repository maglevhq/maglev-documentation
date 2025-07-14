# Dark Mode Toggle Implementation

This project includes a fully functional dark/light mode toggle using Stimulus.js and Tailwind CSS.

## Features

- **Automatic Detection**: Detects user's system preference on first visit
- **Persistent Storage**: Saves user preference in localStorage
- **No Flash**: Prevents flash of unstyled content during page load
- **Smooth Transitions**: Uses Tailwind CSS for consistent theming
- **Accessible**: Proper ARIA labels and keyboard navigation

## How It Works

### 1. Stimulus Controller (`assets/javascripts/controllers/theme_controller.js`)

The controller handles:
- Theme initialization on page load
- Toggle functionality
- localStorage persistence
- Icon state management

### 2. HTML Structure

The toggle button in the topbar includes:
- Stimulus controller attributes
- Two SVG icons (sun for light, moon for dark)
- Proper accessibility attributes

### 3. CSS Classes

Uses Tailwind CSS dark mode classes:
- `dark:` prefix for dark mode styles
- Automatic class toggling on `<html>` element
- Consistent theming across all components

## Usage

### In Templates

The toggle button is automatically included in the topbar. Users can click the sun/moon icon to switch themes.

### Custom Implementation

To add the toggle to other components:

```erb
<button
  data-controller="theme"
  data-action="click->theme#toggle"
  class="your-button-classes"
  aria-label="Toggle dark mode"
>
  <!-- Sun icon for light mode -->
  <svg data-theme="light" data-theme-target="icon" class="size-5">
    <!-- sun icon path -->
  </svg>

  <!-- Moon icon for dark mode -->
  <svg data-theme="dark" data-theme-target="icon" class="size-5 hidden">
    <!-- moon icon path -->
  </svg>
</button>
```

### Adding Dark Mode Styles

Use Tailwind's dark mode classes:

```html
<div class="bg-white dark:bg-zinc-800 text-zinc-900 dark:text-white">
  <h1 class="text-zinc-900 dark:text-white">Title</h1>
  <p class="text-zinc-600 dark:text-zinc-300">Content</p>
</div>
```

## Configuration

The theme toggle can be controlled via settings in `config/settings.yml`:

```yaml
features:
  dark_mode_toggle: true
  theme_persistence: true
```

## Testing

Visit `/theme-demo` to see a comprehensive demonstration of the dark mode toggle with various UI elements.

## Browser Support

- Modern browsers with localStorage support
- Automatic fallback to system preference
- Graceful degradation for older browsers

## Performance

- Minimal JavaScript overhead
- CSS-only theme switching
- Efficient localStorage usage
- No external dependencies beyond Stimulus

## Accessibility

- Proper ARIA labels
- Keyboard navigation support
- High contrast ratios in both themes
- Screen reader friendly
