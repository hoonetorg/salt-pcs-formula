# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "pcs/map.jinja" import pcs with context %}


include:
  - pcs.user

{%- if salt['grains.get']('os_family') in [ 'Debian' ] %}
pcs_install__disable_daemon_start:
  file.managed:
    - name: /usr/sbin/policy-rc.d
    - user: root
    - group: root
    - mode: "0755"
    - contents: |
        #!/bin/bash
        if [ "$2" == "rotate" ] ; then
          exit 0
        fi
        exit 101
    - require:
      - group: pcs_user__user
      - user: pcs_user__user

pcs_install__repopkgpre:
  pkg.installed:
    - pkgs: {{ pcs.repopkgspre }}
    - require:
      - file: pcs_install__disable_daemon_start

pcs_install__repopkg:
  pkg.installed:
    - pkgs: {{ pcs.repopkgs }}
    - fromrepo: {{pcs.repo}}
    - install_recommends: False
    - require:
      - pkg: pcs_install__repopkgpre

pcs_install__initial_corosyncconf_remove:
  file.absent:
    - name: /etc/corosync/corosync.conf
    - onlyif: 
      - grep '^\s*cluster_name. debian$' /etc/corosync/corosync.conf
      - grep '^\s*ringnumber. 0$' /etc/corosync/corosync.conf
      - grep '^\s*bindnetaddr. 127.0.0.1$' /etc/corosync/corosync.conf
      - grep '^\s*mcastport. 5405$' /etc/corosync/corosync.conf
      - grep '^\s*ttl. 1$' /etc/corosync/corosync.conf
    - require:
      - pkg: pcs_install__repopkg
{%- endif %}

pcs_install__pkg:
  pkg.installed:
    - pkgs: {{ pcs.pkgs }}
    - require:
      - group: pcs_user__user
      - user: pcs_user__user
{%- if salt['grains.get']('os_family') in [ 'Debian' ] %}
      - file: pcs_install__initial_corosyncconf_remove
{%- endif %}

