{% if grains['id'] == 'dom0' %}
# Create gpg2 server for personal-dev; debian-12-minimal-vault template
create-personal-dev-gpg2-qvm:
    qvm.vm:
        - name: personal-dev-gpg2
        - present:
            - template: debian-12-minimal-vault
            - label: black
        - prefs:
            - memory: 384
            - maxmem: 768
            - netvm: none
            - vcpus: 1
            - include_in_backups: false
            - autostart: false
            - template_for_dispvms: false
            - default_dispvm: default-dvm
            - qrexec_timeout: 60
            - shutdown_timeout: 60
        - features:
            - set:
                - menu-items: xfce4-terminal.desktop
{% endif %}