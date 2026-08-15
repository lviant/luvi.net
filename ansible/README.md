# Ansible Deployment

If you deploy or extend [luvi.net](https://luvi.net/) from this repo, this directory holds the Ansible playbooks and roles. One shared role handles server configuration; each site has its own role for content and templates. Everything targets an OpenBSD host running [werc](https://werc.cat-v.org/).

## Layout

```
ansible/
├── www.yml                 # Playbook (werc_base + enabled site roles)
├── inventory.ini           # Host inventory (gitignored)
├── inventory.ini.example   # Template with placeholder host
├── group_vars/
│   └── www.yml             # enabled_werc_sites, werc_meta_keywords, werc_projects
└── roles/
    ├── werc_base/          # Shared werc infrastructure
    └── site_<name>/        # One role per site (see below)
```

## Roles

### `werc_base`

Server-wide werc setup, not tied to a single site:

| Path | Purpose |
|------|---------|
| `tasks/main.yml` | rsync package, `httpd.conf`, `acme-client.conf`, TLS renewal cron |
| `tasks/deploy_site.yml` | Shared site deploy logic (included by site roles) |
| `files/initrc.local` | werc global settings; sets `masterSite` so subsites inherit layout partials |
| `templates/_werc/config` | Per-site werc config rendered at deploy |
| `templates/site.webmanifest` | Per-site PWA manifest rendered at deploy |
| `templates/httpd.conf` | OpenBSD httpd vhosts (one block per entry in `enabled_werc_sites`) |
| `templates/acme-client.conf` | Let's Encrypt domains |
| `handlers/main.yml` | Reload httpd, run acme-client |

Tags: `update_config` (httpd + acme config + cron), `update_acme` (acme config + cron only).

### Site Roles

Each deployed site has a role named `site_<hostname_with_underscores>`:

| Role | Hostname | Deployed |
|------|----------|----------|
| `site_luvi_net` | luvi.net | yes |
| `site_gameboy_luvi_net` | gameboy.luvi.net | yes |
| `site_memes_luvi_net` | memes.luvi.net | yes |
| `site_test_luvi_net` | test.luvi.net | no (local mirror only) |

Per-site role layout:

| Path | Purpose |
|------|---------|
| `vars/main.yml` | `werc_site` hostname, `werc_site_tag` deploy tag, and site-specific template variables |
| `files/index.md`, `files/<path>/index.md` | Static pages |
| `files/_docs/<slug>/index.md` | Long-form documents |
| `files/_werc/pub/style.css` | Per-site CSS |
| `files/_werc/lib/` | Layout partials; luvi.net holds the shared set, subsites inherit them |
| `files/_assets/` | Favicons, touch icons, and other static assets served at `/_assets/` |
| `files/favicon.ico` | Legacy favicon (regenerate with `just favicons-luvi` or `just favicons <site> <source>`) |
| `templates/` | Jinja2 pages rendered at deploy (e.g. luvi.net `about/`, `people/`, `projects/`) |
| `tasks/main.yml` | Calls `werc_base` `deploy_site.yml` with this role's `files/` and `templates/` |

## Shared Configuration

Deploy renders `_werc/config` and `site.webmanifest` from `werc_base/templates/`. Do not hand-edit those files in site roles.

### Rendered `_werc/config`

The rendered config sets rc variables that `headers.tpl` reads (`$pageTitle`, `$site_url`, `$meta_description`, `$meta_keywords`). A Jinja template looks up `werc_projects` by matching `name` to `werc_site` (from `vars/main.yml`). That lookup includes the `luvi.net` entry; the template has no per-site special case.

| `werc_projects` field | rc variable | Notes |
|-----------------------|-------------|-------|
| `werc_page_title` | `pageTitle` | omitted when unset |
| `werc_site_title` | `siteTitle` | defaults to `werc_site` |
| `werc_site_sub_title` | `siteSubTitle` | defaults to empty |
| `url` | `site_url` | |
| `werc_meta_desc` | `meta_description` | omitted when unset |
| `werc_cc_exception` | `cc_exception` | omitted when unset |
| (from `werc_meta_keywords`) | `meta_keywords` | shared across all sites |

### Rendered `site.webmanifest`

Each site gets a PWA manifest with icon paths under `/_assets/android-chrome-*.png` in that role's `files/_assets/`. Field values come from the same `werc_projects` lookup as `_werc/config`:

| `werc_projects` field | manifest field |
|-----------------------|----------------|
| `werc_site_title` | `name` (defaults to `werc_site`) |
| (from hostname) | `short_name` (first label, e.g. `memes`) |
| `werc_meta_desc` | `description` (omitted when unset) |
| `url` | `start_url` (omitted when unset) |

Edit `group_vars/www.yml` and/or site templates to change titles, meta tags, or the projects list.

### Deploy Order

For each site:

1. Template `_werc/config` and `site.webmanifest` from `werc_base`
2. Remove inherited layout partials from subsites (see Layout Inheritance)
3. Sync site role `files/` (a subsite shipping its own copy overrides the inherited one)
4. Render site role `templates/`

### Layout Inheritance

Layout partials live in luvi.net `_werc/lib/`. Subsites inherit them through `masterSite`, set in `werc_base/files/initrc.local` (tag `update_config`), because `headers.tpl` and `default_master.tpl` resolve before `_werc/config` is read. Deploy removes those two files from subsite roles so the inherited copies apply instead of stale local overrides.

## Variables

**Shared (`group_vars/www.yml`):**

- `enabled_werc_sites`: hostnames the playbook deploys
- `werc_meta_keywords`: shared keywords string; becomes `meta_keywords` in rendered config (see Shared Configuration)
- `werc_projects`: projects page data (`name`, `url`, `desc`, `emoji`) and per-site werc metadata (`werc_*` fields; see mapping table above)
- `werc_projects` also lists a `luvi.net` entry (excluded from the projects page loop) and off-site links not deployed by Ansible

**Per-site (`vars/main.yml`):**

- `werc_site`, `werc_site_tag`: required on every site role
- `werc_people_links`, `werc_about_banners`: luvi.net
- `gameboy_carousel_len`: gameboy.luvi.net

## Enabling Sites

Edit `group_vars/www.yml`:

```yaml
enabled_werc_sites:
  - luvi.net
  - gameboy.luvi.net
  - memes.luvi.net
```

The playbook applies each site role only when its hostname appears in this list. `site_test_luvi_net` is a local mirror for experimentation. It is not listed in `www.yml`.

## Local Setup

`inventory.ini` is gitignored since it names the real deploy host. Copy the template and fill in your host before running anything locally:

```bash
cp ansible/inventory.ini.example ansible/inventory.ini
# edit ansible/inventory.ini with the real ansible_host
```

GitLab CI supplies inventory through a CI/CD file variable (see `.gitlab-ci.yml`).

## Running

From the repo root, use the justfile:

```bash
just deploy          # content deploy (same as GitLab CI on push to main)
just deploy-sites    # alias for deploy
just deploy-luvi     # deploy luvi.net only
just deploy-gameboy  # deploy gameboy.luvi.net only
just deploy-memes    # deploy memes.luvi.net only
just deploy-site memes_luvi_net  # deploy any site by snake_case tag
just deploy-config   # httpd and TLS configuration (manual)
just deploy-acme     # TLS renewal cron only
just deploy-all      # everything
just check           # playbook syntax check
```

Local runs assume your SSH key is loaded in the agent. Override the remote user when needed:

```bash
just deploy -u you
```

### Assets

Source artwork for favicons lives in `img/` (square PNG recommended). Regenerate all icon formats for a site:

```bash
just favicons <site> <source>   # e.g. just favicons luvi_net img/luvi-icon.png
just favicons-luvi              # img/luvi-icon.png → site_luvi_net
just favicons-memes             # img/savage.png → site_memes_luvi_net
just favicons-gameboy           # img/gameboy-icon.png → site_gameboy_luvi_net (placeholder source)
```

This writes PNGs to `files/_assets/` and a multi-size `favicon.ico` to `files/`. Manifest metadata (`name`, `description`, `start_url`) is rendered at deploy from `werc_projects`; only the icon files need to be generated locally.

Or run ansible directly:

```bash
cd ansible/

# Content deploy (GitLab CI on push to main)
ansible-playbook www.yml -t update_sites -i inventory.ini

# Single site deploy (snake_case tag derived from hostname)
ansible-playbook www.yml -t luvi_net -i inventory.ini

# httpd and TLS configuration (manual)
ansible-playbook www.yml -t update_config -i inventory.ini

# TLS renewal cron only
ansible-playbook www.yml -t update_acme -i inventory.ini
```

Site deploy tasks carry two tags: `update_sites` (all sites) and the per-role `werc_site_tag` (e.g. `luvi_net` for `luvi.net`). CI runs `update_sites` only, syncing content to `/var/www/werc/sites/<hostname>/` on the target host.

## Adding a New Site

1. Create `roles/site_<name>/` with `vars/main.yml` (`werc_site: example.luvi.net`, `werc_site_tag: example_luvi_net`), `files/`, and `tasks/main.yml` following an existing site role. Add `templates/` if the site needs Jinja-rendered pages.
2. Add the hostname to `enabled_werc_sites` in `group_vars/www.yml`.
3. If it is a luvi.net subsite, add a `werc_projects` entry using the fields in Shared Configuration (projects page data and rendered `_werc/config` metadata).
4. Add `_assets/` icons with `just favicons <site> img/<icon>.png` (manifest is auto-rendered on deploy).
5. Add the role to `www.yml` with a `when: "'example.luvi.net' in enabled_werc_sites"` guard.
6. Run `just deploy-config` once so httpd and acme-client pick up the new vhost and certificate.

Do not add `files/_werc/config`; see Shared Configuration.

## Server Paths

On the target host, werc content lands under `/var/www/werc/sites/<hostname>/`. Do not edit those paths directly; change files in the matching site role and redeploy.
