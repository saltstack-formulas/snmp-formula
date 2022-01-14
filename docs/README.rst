.. _readme:

snmp-formula
============

|img_travis| |img_sr| |img_pc|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/snmp-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/snmp-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release
.. |img_pc| image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :alt: pre-commit
   :scale: 100%
   :target: https://github.com/pre-commit/pre-commit

This formula installs the snmp daemon and utilities.

.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please refer to:

- `how to configure the formula with map.jinja <map.jinja.rst>`_
- the ``pillar.example`` file
- the `Special notes`_ section

Contributing to this repo
-------------------------

Commit messages
^^^^^^^^^^^^^^^

**Commit message formatting is significant!!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``. ::

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

Special notes
-------------

None.

Available states
----------------

.. contents::
    :local:

``snmp``
^^^^^^^^

Installs the snmp daemon, starts, and enables the associated snmp service.

``snmp.conf``
^^^^^^^^^^^^^

Configures the snmp daemon.

``snmp.trap``
^^^^^^^^^^^^^

Starts and enables the trap service.

``snmp.conftrap``
^^^^^^^^^^^^^^^^^

Configures the trap service.

``snmp.options``
^^^^^^^^^^^^^^^^

Sets snmp runtime options.


Layered configuration
---------------------

Since SNMP can be integrated with many services, it may be handy to split configuration between several files,
each belonging to different packages and teams.
For example, you may setup generic SNMP configuration in common pillar file, and it will include:

.. code:: yaml

    snmp:
      conf:
        settings:
          logconnects: false
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

Testing
-------

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``TEMPLATE`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.
