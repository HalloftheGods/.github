# Hall of the Gods CI/CD & Organization Repository (`.github`)

Centralized GitHub Actions reusable workflows, health files, and release automation for the **Hall of the Gods** and **Xophz COMPASS** ecosystem.

---

## 📦 Reusable Workflows

All shared workflows live under `.github/workflows/` and can be called from any repository across the organization.

| Workflow | Path | Description |
| :--- | :--- | :--- |
| **Pipeline (Master)** | `.github/workflows/master.yml` | Combined runner for `auto-version` (push/dispatch) and `daily-final` (schedule). |
| **Auto Version** | `.github/workflows/auto-version.yml` | Calculates RC version, updates plugin or theme headers/JSON, tags, and builds release zip. |
| **Daily Final Version** | `.github/workflows/daily-final-version.yml` | Daily batch workflow to promote latest RC to official daily release (`vYY.M.D`). |
| **Calculate Version** | `.github/workflows/calculate-version.yml` | Generates standard date-minute version string (`YY.M.D-MINS`). |
| **WP Plugin Update** | `.github/workflows/wp-plugin-update.yml` | Injects version numbers into PHP headers, constants, `package.json`, and `composer.json`. |
| **WP Theme Update** | `.github/workflows/wp-theme-update.yml` | Injects version numbers into `style.css`, constants, and manifest files. |
| **Build Plugin Zip** | `.github/workflows/build-plugin-zip.yml` | Packages production zip (excluding dev files) and creates/updates GitHub Release. |
| **Build Theme Zip** | `.github/workflows/build-theme-zip.yml` | Packages production theme zip and creates/updates GitHub Release. |
| **Finalize RC Releases** | `.github/workflows/finalize-rc-releases.yml` | Promotes top RC of the day to final tag and purges intermediate RC tags. |
| **Cleanup RC Releases** | `.github/workflows/cleanup-rc-releases.yml` | Manual trigger (`workflow_dispatch`) to run the RC cleanup process. |

---

## 🚀 Quick Usage in Plugins & Themes

### Option A: Universal Pipeline (`master.yml`)

#### For WordPress Plugins:
Add `.github/workflows/compass.yml` to your plugin repository:

```yaml
name: Compass
on:
  push:
    branches: [main]
  schedule:
    - cron: "59 23 * * *"
  workflow_dispatch:

permissions:
  contents: write

jobs:
  pipeline:
    uses: HalloftheGods/.github/.github/workflows/master.yml@main
    with:
      type: plugin
      slug: xophz-compass
```

#### For WordPress Themes:
Add `.github/workflows/compass.yml` to your theme repository:

```yaml
name: Compass
on:
  push:
    branches: [main]
  schedule:
    - cron: "59 23 * * *"
  workflow_dispatch:

permissions:
  contents: write

jobs:
  pipeline:
    uses: HalloftheGods/.github/.github/workflows/master.yml@main
    with:
      type: theme
      slug: xophz-magic-hat
```

### Option B: Auto Version Only (`auto-version.yml`)

```yaml
name: Auto Version
on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: write

jobs:
  auto-version:
    uses: HalloftheGods/.github/.github/workflows/auto-version.yml@main
    with:
      type: theme # or plugin (default)
      slug: xophz-magic-hat
```

---

## 🛠️ Utility Scripts

- `scripts/cleanup-rc-releases.sh`: Local bash script to purge temporary 4-part release candidate tags and releases using the GitHub CLI (`gh`).
