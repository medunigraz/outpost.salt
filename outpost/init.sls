{%- if pillar.outpost is defined %}
include:
{%- if pillar.outpost.get('system', False) %}
 - outpost.groups
 - outpost.users
{%- endif %}
{%- if pillar.outpost.get('borg', []) |length > 0 %}
 - outpost.borg
{%- endif %}
{%- endif %}
