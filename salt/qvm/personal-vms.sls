{% if grains['id'] == 'dom0' %}
# Create personal VMs from pillar configuration
{% for vm_name, vm_config in pillar.get('personal_vms', {}).items() %}
create-{{ vm_name }}-qvm:
  qvm.vm:
    - name: {{ vm_name }}
    - present:
        - template: {{ vm_config.template }}
        - label: {{ vm_config.label }}
    - prefs:
        - memory: {{ vm_config.memory }}
        - maxmem: {{ vm_config.maxmem }}
        - vcpus: {{ vm_config.vcpus }}
        - netvm: {{ vm_config.get('netvm', pillar.get('vm_defaults', {}).get('netvm', 'sys-firewall')) }}
        - autostart: {{ vm_config.get('autostart', pillar.get('vm_defaults', {}).get('autostart', false)) }}
        - include_in_backups: {{ vm_config.get('include_in_backups', pillar.get('vm_defaults', {}).get('include_in_backups', false)) }}
    - features:
        - set:
            - menu-items: {{ vm_config.menu_items | join(' ') }}

# Tags für {{ vm_name }}
{% if vm_config.get('tags') %}
set-tags-{{ vm_name }}:
  qvm.tags:
    - name: {{ vm_name }}
    - tags:
        {% for tag in vm_config.tags %}
        - {{ tag }}
        {% endfor %}
    - require:
        - qvm: create-{{ vm_name }}-qvm
{% endif %}

{% endfor %}
{% endif %}