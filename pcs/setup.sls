# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "pcs/map.jinja" import pcs with context %}

pcs_setup__setup:
  pcs.cluster_setup:
    - nodes: [ '{{pcs.admin_node}}' ]
    - pcsclustername: {{pcs.pcsclustername|default('pcscluster')}} 
    - extra_args: {{pcs.setup_extra_args|default([])}}
