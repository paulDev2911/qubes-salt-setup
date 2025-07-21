{% if grains['id'] == 'dom0' %}
# Clone template for system qubes
debian-12-minimal-sys-clone:
  qvm.clone:
    - name: debian-12-minimal-sys
    - source: debian-12-minimal

# Configure passwordless sudo in the template
debian-12-minimal-sys-configure-passwordless-sudo:
  cmd.run:
    - name: |
        qvm-run -u root debian-12-minimal-sys 'echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/qubes && chmod 440 /etc/sudoers.d/qubes'
    - require:
      - qvm: debian-12-minimal-sys-clone

# Update template packages
debian-12-minimal-sys-update:
  cmd.run:
    - name: qvm-run -u root debian-12-minimal-sys 'apt-get update'
    - require:
      - cmd: debian-12-minimal-sys-configure-passwordless-sudo

# Install essential packages for sys-qubes
debian-12-minimal-sys-packages:
  cmd.run:
    - name: |
        qvm-run -u root debian-12-minimal-sys 'apt install -y \
          qubes-core-agent-networking \
          qubes-core-agent-network-manager \
          iptables \
          nftables \
          iproute2 \
          systemd-resolved'
    - require:
      - cmd: debian-12-minimal-sys-update

# Configure template properties
debian-12-minimal-sys-properties:
  qvm.prefs:
    - name: debian-12-minimal-sys
    - memory: 300
    - maxmem: 500
    - include_in_backups: true
    - require:
      - cmd: debian-12-minimal-sys-packages

# Shutdown template after configuration
debian-12-minimal-sys-shutdown:
  qvm.shutdown:
    - name: debian-12-minimal-sys
    - require:
      - qvm: debian-12-minimal-sys-properties

{% endif %}