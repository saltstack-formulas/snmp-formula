{% from "snmp/map.jinja" import snmp with context %}

snmp-utils:
  pkg.installed:
    - name: {{ snmp.pkgutils }}
