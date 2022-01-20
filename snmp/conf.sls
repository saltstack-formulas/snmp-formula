# vim: ft=sls

{% from "snmp/map.jinja" import snmp with context %}
{% from "snmp/conf.jinja" import conf with context %}
{% from "snmp/macros.jinja" import v3_createUser_string with context -%}

include:
  - snmp

snmp_conf:
  file.managed:
    - name: {{ snmp.config }}
    - makedirs: True
    - template: jinja
    - context:
      config: {{ conf.get('settings', {}) | json }}
    - source: {{ snmp.source }}
    - user: root
    - group: {{ snmp.rootgroup }}
    - mode: 644

{% if 'persistentconfig' in snmp %}
{% for groups in ['rousers', 'rwusers'] %}
{% for user in conf.get(groups, []) %}
{% set securitylevel = 'authPriv' if user.get('securitylevel') == 'priv' else 'authNoPriv' %}
{# if test fails, stop snmpd, add user to persistent config file, restart snmpd #}
snmpv3 creating {{ user.username }} step 1 of 3:
  service.dead:
    - name: {{ snmp.service }}
    - unless:
      - "snmpget -v3 -l {{ securitylevel }} -u {{ user.username }} -a {{ user.get('authproto', 'SHA') }} -A {{ user.authpassphrase }} -x {{ user.get('privproto', 'AES') }} {% if securitylevel == "authPriv" %}-X {{ user.privpassphrase }}{% endif %} 127.0.0.1 1.3.6.1.2.1.1.5.0 -On"

snmpv3 creating {{ user.username }} step 2 of 3:
  file.line:
    - name: {{ snmp.persistentconfig }}
    - mode: insert
    - location: end
    - content: {{ v3_createUser_string(user) }}
    - show_changes: False
    - require:
      - snmpv3 creating {{ user.username }} step 1 of 3

snmpv3 creating {{ user.username }} step 3 of 3:
  service.running:
    - name: {{ snmp.service }}
    - require:
      - snmpv3 creating {{ user.username }} step 2 of 3
{% endfor %}
{% endfor %}
{% endif %}