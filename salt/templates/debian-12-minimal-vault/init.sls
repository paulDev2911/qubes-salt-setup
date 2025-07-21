{% if grains['id'] == 'dom0'%}
# Clone template for vault qubes
debian-12-minimal-vault-clone:
  qvm.clone:
    - name: debian-12-minimal-vault
    - source: debian-12-minimal

# Configure passwordless sudo in the template
debian-12-minimal-vault-configure-passwordless-sudo:
  cmd.run:
    - name: |
        qvm-run -u root debian-12-minimal-vault 'echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/qubes && chmod 440 /etc/sudoers.d/qubes'
    - require:
      - qvm: debian-12-minimal-vault-clone

# Update template packages
debian-12-minimal-vault-update:
  cmd.run:
    - name: qvm-run -u root debian-12-minimal-vault 'apt-get update'
    - require:
      - cmd: debian-12-minimal-vault-configure-passwordless-sudo

# Install essential packages for vault-qubes
debian-12-minimal-vault-packages:
  cmd.run:
    - name: |
        qvm-run -u root debian-12-minimal-vault '
        apt install -y \
          keepassxc \
          gnupg2 \
          qubes-gpg-split \
          pinentry-gtk2 \
          xclip \
          pwgen
        '
    - require:
        - cmd: debian-12-minimal-vault-update

# Configure template properties
debian-12-minimal-vault-properties:
  qvm.prefs:
    - name: debian-12-minimal-vault
    - memory: 300
    - maxmem: 500    
    - include_in_backups: true
    - require:
      - cmd: debian-12-minimal-vault-packages

# Shutdown template after configuration
debian-12-minimal-vault-shutdown:
  qvm.shutdown:
    - name: debian-12-minimal-vault
    - require:
      - qvm: debian-12-minimal-vault-properties

{% endif %}