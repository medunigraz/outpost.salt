{%- for server in pillar.outpost.borg %}
outpost_borg_{{ server.name }}:
  user.present:
    - name: {{ server.username }}
    - system: True
    - home: {{ server.path }}
    - shell: /bin/false
    - createhome: true
    {%- if grains['pythonversion'][0] < 3 %}
    - fullname: "{{ server.name.decode('utf-8') }}"
    {%- else %}
    - fullname: "{{ server.name }}"
    {%- endif %}
    - gid_from_name: true

{%- if server.repositories is iterable %}
{%- if server.repositories |length > 0 %}
outpost_borg_{{ server.name }}_ssh_key:
  ssh_auth.present:
    - user: {{ server.username }}
    - names:
      {%- for repository in server.repositories %}
      - command="borg serve --restrict-to-path {{ repository.path }}",restrict {{ repository.openssh }}
      {% endfor %}
    - require:
      - user: outpost_borg_{{ server.name }}

{%- for repository in server.repositories %}
outpost_borg_{{ server.name }}_repository_{{ repository.name }}:
  file.directory:
    - name: {{ repository.path }}
    - user: {{ server.username }}
    - group: root
    - dir_mode: 700
    - file_mode: 600
    - require:
      - user: outpost_borg_{{ server.name }}
{%- endfor %}
{%- endif %}
{%- endif %}
{%- endfor %}
