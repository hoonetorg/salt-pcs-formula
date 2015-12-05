# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "pcs/map.jinja" import pcs with context %}

pcs_config__corosync_comm_prot:
  module.run:
    - name: pcs.config
    - corosync_comm_prot: {{pcs.corosync_comm_prot}}
