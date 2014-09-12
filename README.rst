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
