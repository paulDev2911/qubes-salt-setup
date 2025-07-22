{% if grains['id'] == 'dom0' %}
# Create email qvm on fedora-41-xfce-personal template
create-personal-thunderbird-qvm:
    qvm.vm:
        - name: personal-thunderbird
        - present:
            - template: fedora-41-xfce-personal
            - label: blue
        - prefs:
            - memory: 1024
            - maxmem: 2048
            - netvm: sys-firewall
            - vcpus: 1
            - include_in_backups: false
            - autostart: false
            - template_for_dispvms: false
            - default_dispvm: default-dvm
            - qrexec_timeout: 60
            - shutdown_timeout: 60
        - features:
            - set:
                - menu-items: brave-browser.desktop net.thunderbird.Thunderbird.desktop
{% endif %}