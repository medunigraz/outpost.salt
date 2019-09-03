{%- if pillar.outpost is defined %}
include:
{%- if pillar.outpost.system is defined %}
 - outpost.groups
 - outpost.users
{%- endif %}
{%- if pillar.outpost.borg is iterable %}
{%- if pillar.outpost.borg |length > 0 %}
 - outpost.borg
{%- endif %}
{%- endif %}
{%- endif %}
