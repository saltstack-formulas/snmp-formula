# vim: ft=sls

{% from "snmp/map.jinja" import snmp with context %}
{% from "snmp/conf.jinja" import conf with context %}
{% from "snmp/macros.jinja" import v3_createUser_string with context %}

include:
  - snmp
  - snmp.utils

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
    - watch_in:
      - service: snmp

{# Handle creation of SNMPv3 users #}
{% if 'dynamicconfig' in snmp %}
{% set modes = ['ro', 'rw'] %}
{% for mode in modes %}
{% for user in conf.get(mode~'users', []) %}
{# convert auth to 'authNoPriv' and priv to 'authPriv' #}
{% set securitylevel = 'authPriv' if user.get('securitylevel') == 'priv' else 'authNoPriv' %}
{# if test fails, stop snmpd, add user to dynamic config file, restart snmpd #}
snmpv3 creating {{ user.username }} step 1 of 3:
  service.dead:
    - name: {{ snmp.service }}
    - unless:
      - "snmpget -v3 -l {{ securitylevel }} -u {{ user.username }} -a {{ user.get('authproto', 'SHA') }} -A {{ user.authpassphrase }} -x {{ user.get('privproto', 'AES') }} {% if securitylevel == "authPriv" %}-X {{ user.privpassphrase }}{% endif %} 127.0.0.1 1.3.6.1.2.1.1.5.0"

snmpv3 creating {{ user.username }} step 2 of 3:
  file.line:
    - name: {{ snmp.dynamicconfig }}
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