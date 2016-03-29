# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "pcs/map.jinja" import pcs with context %}

{% if pcs.properties_extra_cib is defined and pcs.properties_extra_cib %}
pcs_properties__cib_created_{{pcs.properties_extra_cib}}:
  pcs.cib_created:
    - cibname: {{pcs.properties_extra_cib}}
{% endif %}

{% for property, value in pcs.properties.items()|sort %}
pcs_properties__prop_is_set_{{property}}:
  pcs.prop_is_set:
    - prop: {{property}}
    - value: {{value}}
    - require:
      - pcs: pcs_properties__cib_created_{{pcs.properties_extra_cib}}
    - require_in:
      - pcs: pcs_properties__cib_pushed_{{pcs.properties_extra_cib}}
{% if pcs.properties_extra_cib is defined and pcs.properties_extra_cib %}
    - cibname: {{pcs.properties_extra_cib}}
{% endif %}
{% endfor %}

{% if pcs.properties_extra_cib is defined and pcs.properties_extra_cib %}
pcs_properties__cib_pushed_{{pcs.properties_extra_cib}}:
  pcs.cib_pushed:
    - cibname: {{pcs.properties_extra_cib}}
{% endif %}
