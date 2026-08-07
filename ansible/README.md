# Ansible deployment

This directory deploys the [luvi.net](https://luvi.net/) [werc](https://werc.cat-v.org/) sites to an OpenBSD host. One shared role handles server configuration; each site has its own role for content and templates.

## Layout

```
ansible/
├── www.yml                 # Playbook (werc_base + enabled site roles)
├── inventory.ini           # Host inventory
├── group_vars/
│   └── www.yml               # enabled_werc_sites
└── roles/
    ├── werc_base/            # Shared werc infrastructure
    └── site_<name>/          # One role per site (see below)
```

## Roles

### `werc_base`

Server-wide werc setup, not tied to a single site:

| Path | Purpose |
|------|---------|
| `tasks/main.yml` | rsync package, `httpd.conf`, `acme-client.conf`, TLS renewal cron |
| `tasks/deploy_site.yml` | Shared site deploy logic (included by site roles) |
| `files/werc/defaults/` | Layout partials synced to every site before site content |
| `templates/httpd.conf` | OpenBSD httpd vhosts (one block per entry in `enabled_werc_sites`) |
| `templates/acme-client.conf` | Let's Encrypt domains |
| `handlers/main.yml` | Reload httpd, run acme-client |

Tags: `update_config` (httpd + acme config + cron), `update_acme` (acme config + cron only).

### Site roles

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
| `files/` | Static werc content (`index.md`, `_werc/config`, `_werc/pub/style.css`, `_docs/`, assets) |
| `templates/` | Jinja2 pages rendered at deploy time |
| `tasks/main.yml` | Calls `werc_base` `deploy_site.yml` with this role's `files/` and `templates/` |

Site-specific variables live in the site role's `vars/main.yml` (for example `werc_people_links` on luvi.net, `gameboy_carousel_len` on gameboy.luvi.net).

## Enabling sites

Edit `group_vars/www.yml`:

```yaml
enabled_werc_sites:
  - luvi.net
  - gameboy.luvi.net
  - memes.luvi.net
```

The playbook applies each site role only when its hostname appears in this list. `site_test_luvi_net` exists for local experimentation but is not referenced in `www.yml`.

## Running

From the repo root, use the justfile:

```bash
just deploy          # content deploy (same as GitLab CI on push to main)
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
just deploy ansible_user=you
```

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

## Adding a new site

1. Create `roles/site_<name>/` with `vars/main.yml` (`werc_site: example.luvi.net`, `werc_site_tag: example_luvi_net`), `files/`, `templates/` (if needed), and `tasks/main.yml` following an existing site role.
2. Add the hostname to `enabled_werc_sites` in `group_vars/www.yml`.
3. Add the role to `www.yml` with a `when: "'example.luvi.net' in enabled_werc_sites"` guard.
4. Run `update_config` once so httpd and acme-client pick up the new vhost and certificate.

## Server paths

On the target host, werc content lands under `/var/www/werc/sites/<hostname>/`. Do not edit those paths directly; change files in the matching site role and redeploy.
