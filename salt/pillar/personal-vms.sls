personal_vms:
  personal-browser:
    template: fedora-41-xfce-personal
    label: blue
    memory: 1024
    maxmem: 2048
    vcpus: 1
    menu_items:
      - brave-browser.desktop
    tags:
      - browser
      - personal
    
  personal-dev:
    template: fedora-41-xfce-personal
    label: blue
    memory: 2048
    maxmem: 6144
    vcpus: 4
    menu_items:
      - brave-browser.desktop
      - code.desktop
      - xfce4-terminal.desktop
    tags:
      - development
      - personal
    
  personal-thunderbird:
    template: fedora-41-xfce-personal
    label: blue
    memory: 1024
    maxmem: 2048
    vcpus: 1
    menu_items:
      - brave-browser.desktop
      - net.thunderbird.Thunderbird.desktop
    tags:
      - email
      - personal

vm_defaults:
  netvm: sys-firewall
  include_in_backups: false
  autostart: false