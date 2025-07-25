# sys-firewall.sls
# System-Firewall Qube basierend auf debian-12-minimal-sys

sys-firewall:
  qvm.vm:
    - name: sys-firewall
    - present:
      - template: debian-12-minimal-sys
      - label: red
      - netvm: sys-net
      - provides_network: False
      - memory: 400
      - maxmem: 1000
      - vcpus: 2
    - prefs:
      - include_in_backups: False
      - autostart: True
    - features:
      - service.qubes-firewall: 1
      - service.meminfo-writer: 1
    - tags:
      - add:
        - anon-gateway

# Services konfigurieren
sys-firewall-services:
  qvm.service:
    - name: sys-firewall
    - enable:
      - qubes-firewall
      - meminfo-writer
      - network-manager
    - disable:
      - cups
      - cups-browsed
      - pulseaudio

# Firewall auf "alles erlauben" setzen  
sys-firewall-open-policy:
  qvm.firewall:
    - name: sys-firewall
    - policy: allow