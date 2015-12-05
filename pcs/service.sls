# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "pcs/map.jinja" import pcs with context %}

pcs_service__service:
  service.{{ pcs.service.state }}:
    - name: {{ pcs.service.name }}
    - enable: {{ pcs.service.enable }}
