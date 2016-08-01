# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "pcs/map.jinja" import pcs with context %}
{%- if pcs.get('repopkgs', False) %}
pcs_install__repopkgpre:
  pkg.installed:
    - pkgs: {{ pcs.repopkgspre }}
{%- endif %}

{%- if pcs.get('repopkgs', False) %}
pcs_install__repopkg:
  pkg.installed:
    - pkgs: {{ pcs.repopkgs }}
    - fromrepo: {{pcs.repo}}
    - install_recommends: False
    - require:
      - pkg: pcs_install__repopkgpre
{%- endif %}

pcs_install__pkg:
  pkg.installed:
    - pkgs: {{ pcs.pkgs }}
{%- if pcs.get('repopkgs', False) %}
    - require:
      - pkg: pcs_install__repopkg
{%- endif %}

