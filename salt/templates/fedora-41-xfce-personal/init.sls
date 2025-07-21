{% if grains['id'] == 'dom0' %}
# Clone template for personal
fedora-41-xfce-personal-clone:
  qvm.clone:
    - name: fedora-41-xfce-personal
    - source: fedora-41-xfce
  
{% elif grains['id'] == 'fedora-41-xfce-personal' %}
# Refresh package cache
fedora-41-xfce-personal-refresh:
  cmd.run:
    - name: dnf makecache

# Update template packages
fedora-41-xfce-personal-update:
  cmd.run:
    - name: dnf upgrade -y
    - require:
      - cmd: fedora-41-xfce-personal-refresh

# Import Microsoft GPG key
import-microsoft-gpg-key:
  cmd.run:
    - name: rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Create Visual Studio Code repository file
vscode-repo:
  file.managed:
    - name: /etc/yum.repos.d/vscode.repo
    - contents: |
        [code]
        name=Visual Studio Code
        baseurl=https://packages.microsoft.com/yumrepos/vscode
        enabled=1
        autorefresh=1
        type=rpm-md
        gpgcheck=1
        gpgkey=https://packages.microsoft.com/keys/microsoft.asc
    - mode: 644
    - user: root
    - group: root
    - require:
      - cmd: import-microsoft-gpg-key
{% endif %}