================
snmp-formula
================

This formula installs the snmp daemon and utilities.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``snmp``
------------

Installs the snmp daemon, starts, and enables the associated snmp service.

``snmp.conf``
------------

Configures the snmp daemon.

``snmp.trap``
------------

Starts and enables the trap service.

``snmp.conftrap``
------------

Configures the trap service.

``snmp.options``
------------

Sets snmp runtime options.


Layered configuration
=====================

Since SNMP can be integrated with many services, it may be handy to split configuration between several files,
each belonging to different packages and teams.
For example, you may setup generic SNMP configuration in common pillar file, and it will include:

.. code:: yaml

    snmp:
      conf:
        settings:
          dontLogTCPWrappersConnects: true
          sysServices: 72

Whereas team, that wants to monitor GPFS with SNMP on the same cluster will add this pillar file to their package:

.. code:: yaml

    snmp:
      conf:
        settings:
          master: ['agentx']
          AgentXSocket: tcp:localhost:705
        rocommunities:
          - gpfs
        mibs:
          GPFS: salt://gpfs/files/GPFS-mib.txt

To utilize this ability of layered configuration, you can modify snmp/conf.jinja file in following manner:

.. code:: jinja

    # Generic configuration:
    {% set conf = salt['pillar.get']('snmp:conf', {}) %}

    # Imagine you have team_names list which consist of packages provided
    # by set of independent teams inside your company:
    {% for team in team_names %}
    {% set conf = salt['pillar.get'](
        team + ":snmp",
        default=conf,
        merge=True)
    %}
    {% endfor %}

    # Afterall there might configuration specific to current deployment in separate pillar file:
    {% set conf = salt['pillar.get'](
        "user:snmp",
        default=conf,
        merge=True)
    %}
