{% if grains['id'] == 'dom0' %}
clone-template:
  qvm.clone:
    - name: fedora-41-xfce-personal
    - source: fedora-41-xfce
configure-template:
  qvm.prefs:
    - name: fedora-41-xfce-personal
    - label: black
    - memory: 500
    - maxmem: 4096
    - vcpus: 2
    - require:
      - qvm: clone-template
{% else %}
# Keys von dom0 zu Template kopieren
copy-microsoft-key:
  file.managed:
    - name: /tmp/microsoft.asc
    - source: salt://microsoft.asc

copy-brave-key:
  file.managed:
    - name: /tmp/brave.asc
    - source: salt://brave.asc

vscode-key:
  cmd.run:
    - name: rpm --import /tmp/microsoft.asc
    - unless: rpm -qi gpg-pubkey-eb3e94ad-*
    - require:
      - file: copy-microsoft-key

brave-key:
  cmd.run:
    - name: rpm --import /tmp/brave.asc
    - unless: rpm -qi gpg-pubkey-* | grep -q "Brave Software"
    - require:
      - file: copy-brave-key

vscode-repo:
  pkgrepo.managed:
    - name: code
    - humanname: Visual Studio Code
    - baseurl: https://packages.microsoft.com/yumrepos/vscode
    - gpgcheck: 1
    - gpgkey: file:///tmp/microsoft.asc
    - require:
      - cmd: vscode-key

brave-repo:
  pkgrepo.managed:
    - name: brave-browser
    - humanname: Brave Browser
    - baseurl: https://brave-browser-rpm-release.s3.brave.com/$basearch
    - gpgcheck: 1
    - gpgkey: file:///tmp/brave.asc
    - require:
      - cmd: brave-key

install-software:
  pkg.installed:
    - pkgs:
      - code
      - brave-browser
      - git
      - python3
      - python3-pip
      - make
    - require:
      - pkgrepo: vscode-repo
      - pkgrepo: brave-repo
{% endif %}