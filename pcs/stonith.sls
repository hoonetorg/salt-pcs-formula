# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "pcs/map.jinja" import pcs with context %}

{% if pcs.stonith_cib is defined and pcs.stonith_cib %}
pcs_stonith__cib_present_{{pcs.stonith_cib}}:
  pcs.cib_present:
    - cibname: {{pcs.stonith_cib}}
{% endif %}

{% if 'stonith_resources' in pcs %}
{% for stonith_resource, stonith_resource_data in pcs.stonith_resources.items()|sort %}
pcs_stonith__present_{{stonith_resource}}:
  pcs.stonith_present:
    - stonith_id: {{stonith_resource_data.stonith_id}}
    - stonith_device_type: {{stonith_resource_data.stonith_device_type}}
    - stonith_device_options: {{stonith_resource_data.stonith_device_options}}
{% if pcs.stonith_cib is defined and pcs.stonith_cib %}
    - require:
      - pcs: pcs_stonith__cib_present_{{pcs.stonith_cib}}
    - require_in:
      - pcs: pcs_stonith__cib_pushed_{{pcs.stonith_cib}}
    - cibname: {{pcs.stonith_cib}}
{% endif %}
{% endfor %}
{% endif %}

{% if pcs.stonith_cib is defined and pcs.stonith_cib %}
pcs_stonith__cib_pushed_{{pcs.stonith_cib}}:
  pcs.cib_pushed:
    - cibname: {{pcs.stonith_cib}}
{% endif %}

pcs_stonith__empty_sls_prevent_error:
  cmd.run:
    - name: "true"
    - unless: "true"


