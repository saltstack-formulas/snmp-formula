# vim: ft=sls

{% from "snmp/map.jinja" import snmp with context -%}

{% if 'pkgutils' in snmp -%}
snmp_utils:
  pkg.installed:
    - name: {{ snmp.pkgutils }}
{% endif -%}