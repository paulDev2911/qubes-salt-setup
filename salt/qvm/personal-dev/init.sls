{% if grains['id'] == 'dom0' %}
# Create development qvm on fedora-41-xfce-personal-template
create-development-qvm:
    qvm.vm:
        - name: personal-dev
        - present:
            - template: fedora-41-xfce-personal
            - label: blue
        - prefs:
            - memory: 2048
            - maxmem: 6144
            - netvm: sys-firewall
            - vcpus: 4
            - include_in_backups: false
            - autostart: false
            - template_for_dispvms: false
            - default_dispvm: default-dvm
            - qrexec_timeout: 60
            - shutdown_timeout: 60
        - features:
            - set:
                - menu-items: brave-browser.desktop code.desktop xfce4-terminal.desktop
{% endif %}