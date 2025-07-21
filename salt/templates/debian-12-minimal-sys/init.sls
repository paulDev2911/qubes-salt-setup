# Clone template for system qubes
debian-12-minimal-sys:
  qvm.clone:
    - source: debian-12-minimal
    - label: black

# Start template for configuration
debian-12-minimal-sys-start:
  qvm.start:
    - name: debian-12-minimal-sys
    - require:
      - qvm: debian-12-minimal-sys

# Ensure template is updated
debian-12-minimal-sys-update:
  cmd.run:
    - name: qvm-run -u root debian-12-minimal-sys 'apt update && apt upgrade -y'
    - require:
      - qvm: debian-12-minimal-sys-start

# Install only essential packages for sys-qubes
debian-12-minimal-sys-packages:
  cmd.run:
    - name: |
        qvm-run -u root debian-12-minimal-sys '
        apt install -y \
          qubes-core-agent-networking \
          qubes-core-agent-network-manager \
          iptables \
          nftables \
          iproute2 \
          systemd-resolved
        '
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