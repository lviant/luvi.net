# Ansible Deployment

This directory deploys the [luvi.net](https://luvi.net/) [werc](https://werc.cat-v.org/) sites to an OpenBSD host. One shared role handles server configuration; each site has its own role for content and templates.

## Layout

```
ansible/
├── www.yml                 # Playbook (werc_base + enabled site roles)
├── inventory.ini           # Host inventory
├── group_vars/
│   └── www.yml             # enabled_werc_sites, werc_projects
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
| `templates/_werc/config` | Per-site werc config rendered at deploy time |
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
| `files/site.webmanifest` | PWA manifest (references icons in `_assets/`) |
| `files/favicon.ico` | Legacy favicon (regenerate with `just favicons-luvi` or `just favicons <site> <source>`) |
| `templates/` | Jinja2 pages rendered at deploy time (e.g. luvi.net `about/`, `people/`, `projects/`) |
| `tasks/main.yml` | Calls `werc_base` `deploy_site.yml` with this role's `files/` and `templates/` |

## Shared Configuration

`_werc/config` is not hand-edited per site. Deploy renders it from `werc_base/templates/_werc/config` using each site's `werc_site` (from `vars/main.yml`). Subsites get `masterSite`, subtitle, URL, and meta description from matching entries in `werc_projects`. To change subsite titles/descriptions or the projects list, edit `group_vars/www.yml` and/or the projects template (not a per-site config file).

Deploy order for each site:

1. Template `_werc/config` from `werc_base`
2. Remove `_werc/lib/headers.tpl` and `_werc/lib/default_master.tpl` from subsites
3. Sync site role `files/` (a subsite shipping its own copy overrides the inherited one)
4. Render site role `templates/`

Layout partials live in the main site's `_werc/lib/`; subsites inherit them via `masterSite`. `headers.tpl` and `default_master.tpl` resolve before `_werc/config` is read, so `masterSite` is set globally in `werc_base/files/initrc.local` (tag `update_config`) instead.

## Variables

**Shared (`group_vars/www.yml`):**

- `enabled_werc_sites` — hostnames the playbook deploys
- `werc_projects`: project list for the luvi.net projects page and subsite metadata (`name`, `url`, `desc`, `emoji`, optional `meta_desc` / `cc_exception`). May include off-site links not deployed by ansible.

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

The playbook applies each site role only when its hostname appears in this list. `site_test_luvi_net` exists for local experimentation but is omitted from `www.yml`.

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

Assumes your SSH key is loaded in the agent. Override the remote user when needed:

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

This writes PNGs to `files/_assets/` and a multi-size `favicon.ico` to `files/`.

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

Site deploy tasks are tagged with both `update_sites` (all sites) and `werc_site_tag` from each site role (e.g. `luvi_net` for `luvi.net`, `gameboy_luvi_net` for `gameboy.luvi.net`).

CI runs `update_sites` only. It syncs werc defaults, static site files, and rendered templates to `/var/www/werc/sites/<hostname>/` on the target host.

## Adding a New Site

1. Create `roles/site_<name>/` with `vars/main.yml` (`werc_site: example.luvi.net`, `werc_site_tag: example_luvi_net`), `files/`, `templates/` (if needed), and `tasks/main.yml` following an existing site role.
2. Add the hostname to `enabled_werc_sites` in `group_vars/www.yml`.
3. If it is a luvi.net subsite, add a `werc_projects` entry (for the projects page and auto-generated `_werc/config` fields).
4. Add `_assets/` icons (`just favicons <site> img/<icon>.png`) and `site.webmanifest` following an existing site role.
5. Add the role to `www.yml` with a `when: "'example.luvi.net' in enabled_werc_sites"` guard.
6. Run `just deploy-config` once so httpd and acme-client pick up the new vhost and certificate.

Do not create `files/_werc/config`; that file is rendered from `werc_base`.

## Server Paths

On the target host, werc content lands under `/var/www/werc/sites/<hostname>/`. Do not edit those paths directly; change files in the matching site role and redeploy.
