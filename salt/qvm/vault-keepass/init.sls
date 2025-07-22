{% if grains['id'] == 'dom0' %}
# Create browsing qvm on fedora-41-xfce-personal template
create-vault-keepass-qvm:
    qvm.vm:
        - name: vault-keepass
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
                - menu-items: org.keepassxc.KeePassXC.desktop
{% endif %}