# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "pcs/map.jinja" import pcs with context %}

{% if pcs.cluster_settings_cib is defined and pcs.cluster_settings_cib %}
pcs_properties__cib_created_{{pcs.cluster_settings_cib}}:
  pcs.cib_created:
    - cibname: {{pcs.cluster_settings_cib}}
{% endif %}

{% if 'properties' in pcs %}
{% for property, value in pcs.properties.items()|sort %}
pcs_properties__prop_is_set_{{property}}:
  pcs.prop_is_set:
    - prop: {{property}}
    - value: {{value}}
    - require:
      - pcs: pcs_properties__cib_created_{{pcs.cluster_settings_cib}}
    - require_in:
      - pcs: pcs_properties__cib_pushed_{{pcs.cluster_settings_cib}}
{% if pcs.cluster_settings_cib is defined and pcs.cluster_settings_cib %}
    - cibname: {{pcs.cluster_settings_cib}}
{% endif %}
{% endfor %}
{% endif %}

{% if 'defaults' in pcs %}
{% for default, value in pcs.defaults.items()|sort %}
pcs_properties__resource_defaults_to_{{default}}:
  pcs.resource_defaults_to:
    - default: {{default}}
    - value: {{value}}
    - require:
      - pcs: pcs_properties__cib_created_{{pcs.cluster_settings_cib}}
    - require_in:
      - pcs: pcs_properties__cib_pushed_{{pcs.cluster_settings_cib}}
{% if pcs.cluster_settings_cib is defined and pcs.cluster_settings_cib %}
    - cibname: {{pcs.cluster_settings_cib}}
{% endif %}
{% endfor %}
{% endif %}

{% if 'op_defaults' in pcs %}
{% for op_default, value in pcs.op_defaults.items()|sort %}
pcs_properties__resource_op_defaults_to_{{op_default}}:
  pcs.resource_op_defaults_to:
    - op_default: {{op_default}}
    - value: {{value}}
    - require:
      - pcs: pcs_properties__cib_created_{{pcs.cluster_settings_cib}}
    - require_in:
      - pcs: pcs_properties__cib_pushed_{{pcs.cluster_settings_cib}}
{% if pcs.cluster_settings_cib is defined and pcs.cluster_settings_cib %}
    - cibname: {{pcs.cluster_settings_cib}}
{% endif %}
{% endfor %}
{% endif %}

{% if pcs.cluster_settings_cib is defined and pcs.cluster_settings_cib %}
pcs_properties__cib_pushed_{{pcs.cluster_settings_cib}}:
  pcs.cib_pushed:
    - cibname: {{pcs.cluster_settings_cib}}
{% endif %}
