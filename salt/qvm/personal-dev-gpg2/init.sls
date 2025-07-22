{% if grains['id'] == 'dom0' %}
# Create GPG2 server Qube for split-gpg2 setup
create-personal-dev-gpg2-qvm:
  qvm.vm:
    - name: personal-dev-gpg2
    - present:
        - template: debian-12-minimal-vault
        - label: black
    - prefs:
        memory: 384
        maxmem: 768
        netvm: ''
        vcpus: 1
        include_in_backups: false
        autostart: false
        template_for_dispvms: false
        default_dispvm: default-dvm
    - features:
        menu-items: xfce4-terminal.desktop
{% endif %}
