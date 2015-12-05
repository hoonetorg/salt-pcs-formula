================
pacemaker-formula
================

A saltstack formula that can install pcs (pacemaker configuration system)
Along with pcs pacemaker and corosync are installed.
With pcs pacemaker and corosync can be configured.
This includes creating resources.

.. note::

    This module is a WIP. 
    Creating resources shouldn't break existing resources.

Available moddule
================

.. contents::
    :local:

``pcs``
------------

call pcs commands

Available states
================

.. contents::
    :local:

``pcs``
------------

Installs the pcs package, and starts the associated pcsd service.

``pacemaker.resources``
------------

Configures pacemaker resources.
