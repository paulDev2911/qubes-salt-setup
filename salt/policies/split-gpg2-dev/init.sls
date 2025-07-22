# init.sls to setup split-gpg2 (personal-dev <-> personal-dev-gpg2)
# i'd rather set it up manually

{% if grains['id'] == 'dom0' %}

# Policy in dom0
split_gpg2_policy:
  file.managed:
    - name: /etc/qubes/policy.d/30-user-gpg2.policy
    - contents: |
        qubes.Gpg2 + personal-dev @default allow target=personal-dev-gpg
    - mode: 0644
    - user: root
    - group: root

# split-gpg2-client in client personal-dev
enable_split_gpg2_client:
  cmd.run:
    - name: qvm-service personal-dev split-gpg2-client on
    - require:
      - file: split_gpg2_policy

{% elif grains['id'] == 'personal-dev-gpg' %}

# create batch
gpg_key_batch_file:
  file.managed:
    - name: /home/user/gpg-key-batch.conf
    - contents: |
        %echo Generating default key
        Key-Type: RSA
        Key-Length: 4096
        Name-Real: Personal Dev
        Name-Email: dev@example.com
        Expire-Date: 0
        %no-protection
        %commit
        %echo Done
    - user: user
    - group: user
    - mode: 0644

# generate gpg-keys
generate_gpg_key:
  cmd.run:
    - name: gpg --batch --generate-key /home/user/gpg-key-batch.conf
    - runas: user
    - require:
      - file: gpg_key_batch_file

# export public key
export_public_keys:
  cmd.run:
    - name: gpg --export > /home/user/public-keys-export
    - runas: user
    - require:
      - cmd: generate_gpg_key

# export ownertrust
export_ownertrust:
  cmd.run:
    - name: gpg --export-ownertrust > /home/user/ownertrust-export
    - runas: user
    - require:
      - cmd: export_public_keys

{% elif grains['id'] == 'personal-dev' %}

# 5a. Öffentliche Schlüssel importieren (nach manuellem/qvm-copy Transfer!)
import_public_keys:
  cmd.run:
    - name: gpg --import ~/QubesIncoming/personal-dev-gpg/public-keys-export
    - require:
      - cmd: enable_split_gpg2_client

# 5b. Ownertrust importieren
import_ownertrust:
  cmd.run:
    - name: gpg --import-ownertrust ~/QubesIncoming/personal-dev-gpg/ownertrust-export
    - require:
      - cmd: import_public_keys

{% endif %}
