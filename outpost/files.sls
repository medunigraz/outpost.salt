#!jinja|yaml|gpg

{%- for file in pillar.outpost.system.get('files', []) %}
outpost_file_{{ file.path }}:
  file.managed:
    - name: {{ file.path }}
    - source: salt://outpost/{{ file.source }}
    - source_hash: {{ file.sha256 }}
    - mode: {{ file.permissions }}
    - owner: {{ file.owner }}
    - makedirs: True
    - unless:
      - sha256sum {{ file.path }} |grep '^{{ file.sha256 }} '
    - require:
      - user: outpost_user_{{ file.owner }}
{%- endfor %}
