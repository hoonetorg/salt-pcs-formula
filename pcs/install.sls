# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "pcs/map.jinja" import pcs with context %}

pcs_install__pkg:
  pkg.installed:
    - name: {{ pcs.pkg }}
