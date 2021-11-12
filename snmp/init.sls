# vim: ft=sls

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
snmpget_install:
  pkg.installed:
    - name: snmp
{% if grains['osmajorrelease'] < 9 %}
include:
  - snmp.default
{% endif %}
{% endif %}