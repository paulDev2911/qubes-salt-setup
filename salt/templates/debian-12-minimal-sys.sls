{% if grains['id'] == 'dom0' %}
# Clone and configure system template
debian-12-minimal-sys-clone:
  qvm.clone:
    - name: debian-12-minimal-sys
    - source: debian-12-minimal

# Configure template properties
debian-12-minimal-sys-properties:
  qvm.prefs:
    - name: debian-12-minimal-sys
    - memory: 400
    - maxmem: 800
    - include_in_backups: true
    - netvm: sys-firewall
    - require:
      - qvm: debian-12-minimal-sys-clone

{% elif grains['id'] == 'debian-12-minimal-sys' %}
# Template configuration when running IN the template
configure-passwordless-sudo:
  file.managed:
    - name: /etc/sudoers.d/qubes-user
    - contents: |
        user ALL=(ALL) NOPASSWD: ALL
    - mode: 440
    - user: root
    - group: root

update-package-cache:
  pkg.uptodate:
    - require:
      - file: configure-passwordless-sudo

install-sys-packages:
  pkg.installed:
    - pkgs:
      # Core networking
      - qubes-core-agent-networking
      - qubes-core-agent-network-manager
      - network-manager
      
      # Firewall & routing
      - iptables
      - iptables-persistent
      - nftables
      - iproute2
      - iputils-ping
      - dnsutils
      
      # System essentials
      - systemd-resolved
      - ca-certificates
      - curl
      - wget
      
      # Debugging tools
      - netcat-openbsd
      - tcpdump
      - ss
      - lsof
      
      # Whonix support
      - tor
      - obfs4proxy
    - require:
      - pkg: update-package-cache

enable-networking-services:
  service.enabled:
    - names:
      - NetworkManager
      - systemd-resolved
      - systemd-networkd
    - require:
      - pkg: install-sys-packages

configure-networkmanager:
  file.managed:
    - name: /etc/NetworkManager/NetworkManager.conf
    - contents: |
        [main]
        plugins=keyfile
        dns=systemd-resolved
        
        [logging]
        level=INFO
    - require:
      - pkg: install-sys-packages

configure-resolved:
  file.managed:
    - name: /etc/systemd/resolved.conf
    - contents: |
        [Resolve]
        DNS=1.1.1.1 8.8.8.8
        FallbackDNS=9.9.9.9
        DNSSEC=yes
        DNSOverTLS=opportunistic
    - require:
      - pkg: install-sys-packages

{% endif %}