# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "pcs/map.jinja" import pcs with context %}

pcs_auth__auth:
  pcs.auth:
    - nodes:  {{pcs.nodes}}
    - pcsuser: {{pcs.pcsuser|default('hacluster')}} 
    - pcspasswd: {{pcs.pcspasswd|default('hacluster')}}
    - extra_args: {{pcs.pcspasswd|default([])}}
