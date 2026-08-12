# Local deployment wrappers for ansible/.
# Assumes your SSH key is loaded in the agent.
# Override user: just deploy -u you  (or: just deploy ansible_user=you)

ansible_dir := "ansible"

# Leave empty to use your default SSH config for the inventory host.
ansible_user := ""

ansible_ssh_flags := if ansible_user != "" { "-u " + ansible_user + " " } else { "" }

_default:
  @just --list

[private]
_playbook user="" *args:
  cd {{ansible_dir}} && ansible-playbook www.yml -i inventory.ini {{ if user != "" { "-u " + user + " " } else { ansible_ssh_flags } }}{{args}}

# Sync site content and templates (same as GitLab CI on push to main).
[arg("user", short="u", long="user")]
deploy user="": (_playbook user "-t update_sites")

alias deploy-sites := deploy

# Verify playbook syntax.
[arg("user", short="u", long="user")]
check user="": (_playbook user "--syntax-check")

# Deploy a single site by snake_case tag (werc_site_tag).
[arg("user", short="u", long="user")]
deploy-luvi user="": (_playbook user "-t luvi_net")

[arg("user", short="u", long="user")]
deploy-gameboy user="": (_playbook user "-t gameboy_luvi_net")

[arg("user", short="u", long="user")]
deploy-memes user="": (_playbook user "-t memes_luvi_net")

[arg("user", short="u", long="user")]
deploy-site site user="": (_playbook user "-t " + site)

# Update httpd and acme-client configuration plus TLS renewal cron.
[arg("user", short="u", long="user")]
deploy-config user="": (_playbook user "-t update_config")

# Update acme-client configuration and TLS renewal cron only.
[arg("user", short="u", long="user")]
deploy-acme user="": (_playbook user "-t update_acme")

# Full deploy: content, httpd, and TLS configuration.
[arg("user", short="u", long="user")]
deploy-all user="": (_playbook user)

# Regenerate web/static/favicon.ico from img/icon.png (16x16 + 32x32).
favicon-luvi:
    magick img/luvi-icon.png -define icon:auto-resize=16,32 ansible/roles/site_luvi_net/files/favicon.ico
