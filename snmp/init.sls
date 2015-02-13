{% from "snmp/map.jinja" import snmp with context %}

snmp:
  pkg.installed:
    - name: {{ snmp.pkg }}
  service.running:
    - name: {{ snmp.service }}
    - enable: true
    - require:
      - pkg: {{ snmp.pkg }}

{% if grains['os_family'] == 'Debian' %}
include:
  - snmp.default
{% endif %}
