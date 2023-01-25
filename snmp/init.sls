{% from "snmp/map.jinja" import snmp with context %}

{% if (snmp is defined) and (snmp.use is defined) -%}

{% if snmp.use | to_bool -%}

snmp:
  pkg.installed:
    - name: {{ snmp.pkg }}
  service.running:
    - name: {{ snmp.service }}
    - enable: true
    - require:
      - pkg: {{ snmp.pkg }}

{% if grains['os_family'] == 'Debian' and grains['osmajorrelease'] < 9 %}
include:
  - snmp.default
{% endif %}

{%- else -%}

snmp_stopped:  
  service.dead:
    - name: {{ snmp.service }}
    - enable: False
snmp_removal:
  pkg.removed:
    - name: {{ snmp.pkg }}
    - require:
      - service: {{ snmp.service }}

{%- endif %}

{%- endif %}