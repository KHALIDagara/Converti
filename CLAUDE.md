# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Rails 8 application for generating and managing landing pages. Built with modern Rails stack using Hotwire (Turbo + Stimulus) and Tailwind CSS.

**Ruby Version:** 3.4.4
**Rails Version:** 8.0.4

## Core Domain Models

### LandingPage
- Has many Services (one-to-many relationship)
- Stores configuration in JSON fields:
  - `styles`: Contains colors (primaryColor, secondaryColor) and fonts (primaryFont, secondaryFont)
  - `copywriting`: Contains hero_section (heading, subheading) and other content
- Uses Active Storage for attachments: `hero_video`, `logo`, `background_image`
- Initializes with defaults via `after_initialize :set_defaults` callback for new records

### Service
- Belongs to LandingPage
- Has one attached image via Active Storage
- Simple model with title and description

## Development Commands

### Server
```bash
# Start development server (Tailwind is currently disabled)
bin/dev

# Or start rails server only
bin/rails server
```

### Database
```bash
# Run migrations
bin/rails db:migrate

# Reset database
bin/rails db:reset

# Rollback last migration
bin/rails db:rollback
```

### Testing
```bash
# Run all tests
bin/rails test

# Run specific test file
bin/rails test test/models/landing_page_test.rb

# Run system tests
bin/rails test:system
```

### Code Quality
```bash
# Run RuboCop linter (uses Omakase styling)
bundle exec rubocop

# Auto-fix violations
bundle exec rubocop -a

# Security audit
bundle exec brakeman
```


## Architecture Notes

### JSON Field Defaults
The LandingPage model uses a custom pattern for JSON field initialization. Default values are set via `after_initialize` callback only for new records, using dedicated private methods `set_default_styles` and `set_default_copywriting`. This keeps initialization logic clean and single-purpose.

### Active Storage
Both models use Active Storage for file attachments. LandingPage has multiple attachments (video, logo, background), while Service has a single image attachment.

### Nested Routing
Services are nested under LandingPages (`/landing_pages/:landing_page_id/services`). Only new, create, edit, update, and destroy actions are available for services - they are always accessed through their parent landing page.

### Controller Pattern
Standard Rails scaffold controllers with `before_action :set_resource` for show/edit/update/destroy actions. Uses Rails 8's `params.expect()` for strong parameters instead of the older `params.require().permit()` pattern.

**Strong Parameters for Nested JSON:** When permitting nested JSON attributes (like `styles` and `copywriting`), use nested hash syntax:
```ruby
params.expect(landing_page: [
  :title,
  { copywriting: { hero_section: [:heading, :subheading] } },
  { styles: { colors: [:primaryColor, :secondaryColor], fonts: [:primaryFont, :secondaryFont] } }
])
```

### Turbo Stream Integration
ServicesController responds to Turbo Stream format for create, update, and destroy actions, enabling inline CRUD operations without full page reloads. After successful operations, it redirects HTML format to the parent landing page's edit page.

### Tech Stack
- **Frontend:** Hotwire (Turbo Rails + Stimulus), Importmap for JS
- **Note:** Tailwind CSS gem is currently disabled (commented out in Gemfile and Procfile.dev)
- **Database:** SQLite3 with Active Storage for file uploads
- **Background Jobs:** Solid Queue (database-backed)
- **Caching:** Solid Cache (database-backed)
- **WebSockets:** Solid Cable (database-backed)
- **Deployment:** Kamal with Docker support

### Testing Framework
Uses default Rails minitest framework with:
- Model tests in `test/models/`
- Controller tests in `test/controllers/`
- System tests in `test/system/` (Capybara + Selenium)
