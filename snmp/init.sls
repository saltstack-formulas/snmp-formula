# vim: ft=sls

{% from "snmp/map.jinja" import snmp with context %}

snmp:
  pkg.installed:
    - name: {{ snmp.pkg }}
  service.enabled:
    - name: {{ snmp.service }}
    - require:
      - pkg: {{ snmp.pkg }}
  service.running:
    - name: {{ snmp.service }}
    - watch:
      - file: {{ snmp.config }}

{% if grains['os_family'] == 'Debian' and grains['osmajorrelease'] < 9 %}
include:
  - snmp.default
{% endif %}
