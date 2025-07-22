{% if grains['id'] == 'dom0' %}
# Clone template for vault qubes
debian-12-minimal-vault-clone:
  qvm.clone:
    - name: debian-12-minimal-vault
    - source: debian-12-minimal

# Configure template properties
debian-12-minimal-vault-properties:
  qvm.prefs:
    - name: debian-12-minimal-vault
    - memory: 300
    - maxmem: 500    
    - include_in_backups: true
    - require:
      - qvm: debian-12-minimal-vault-clone

{% else %}
# Template configuration via disp-mgmt

# Configure passwordless sudo
configure-passwordless-sudo:
  file.managed:
    - name: /etc/sudoers.d/qubes
    - contents: "user ALL=(ALL) NOPASSWD: ALL"
    - mode: 440
    - user: root
    - group: root

# Update package lists
update-packages:
  cmd.run:
    - name: apt-get update
    - runas: root
    - require:
      - file: configure-passwordless-sudo

# Install essential packages for vault-qubes
install-vault-packages:
  pkg.installed:
    - pkgs:
      - keepassxc
      - gnupg2
      - qubes-gpg-split
      - pinentry-gtk2
      - xclip
      - pwgen
    - require:
      - cmd: update-packages

{% endif %}