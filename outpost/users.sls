{% set saltversion = salt['grains.get']('saltversion') %}
{%- for user in pillar.outpost.system.get('users', []) %}
outpost_user_{{ user.username }}:
  user.present:
    - name: {{ user.username }}
    - uid: {{ user.uid }}
    - home: {{ user.homedir }}
    - shell: {{ user.shell }}
    - createhome: true
    - allow_uid_change: true
    - allow_gid_change: true
    {%- if grains['pythonversion'][0] < 3 %}
    - fullname: "{{ user.displayname.decode('utf-8') }}"
    {%- else %}
    - fullname: "{{ user.displayname }}"
    {%- endif %}
    {%- if salt['pkg.version_cmp'](saltversion, '3001') < 0 %}
    - gid_from_name: true
    {%- else %}
    - usergroup: false
    {%- endif %}
    {%- if user.groups is defined %}
    - groups:
    {%- for group in user.groups %}
        - {{ group.name }}
    {%- endfor %}
    {%- endif %}
    - require:
        - group: outpost_group_{{ user.username }}
    {%- for group in user.groups %}
        - group: outpost_group_{{ group.name }}
    {%- endfor %}

{%- if user.public_keys is iterable %}
{%- if user.public_keys|length > 0 %}
outpost_user_{{ user.username }}_ssh_key:
  ssh_auth.present:
    - user: {{ user.username }}
    - names:
{%- for key in user.public_keys %}
{%- if key.openssh is defined %}
      - {{ key.openssh }}
{%- else %}
      - {{ key.key }}
{%- endif %}
{%- endfor %}
    - require:
      - user: outpost_user_{{ user.username }}
{%- endif %}
{%- endif %}

{%- if user.get('sudo', False) %}
outpost_user_{{ user.username }}_sudo:
  file.managed:
    - name: /etc/sudoers.d/{{ user.username }}
    - contents: |
        {{ user.username }}    ALL=(ALL:ALL) NOPASSWD:ALL
    - user: root
    - group: root
    - mode: 400
    - require:
      - user: outpost_user_{{ user.username }}
{%- endif %}
{%- endfor %}
