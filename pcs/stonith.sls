# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "pcs/map.jinja" import pcs with context %}

{% if pcs.stonith_extra_cib is defined and pcs.stonith_extra_cib %}
pcs_stonith__cib_created_cib_for_stonith:
  pcs.cib_created:
    - cibname: {{pcs.stonith_extra_cib}}
{% endif %}

{% for stonith_resource, stonith_resource_data in pcs.stonith_resources.items()|sort %}
pcs_stonith__create_{{stonith_resource}}:
  pcs.stonith_created:
    - stonith_id: {{stonith_resource_data.stonith_id}}
    - stonith_device_type: {{stonith_resource_data.stonith_device_type}}
    - stonith_device_options: {{stonith_resource_data.stonith_device_options}}
{% if pcs.stonith_extra_cib is defined and pcs.stonith_extra_cib %}
    - cibname: {{pcs.stonith_extra_cib}}
{% endif %}
{% endfor %}

{% if pcs.stonith_extra_cib is defined and pcs.stonith_extra_cib %}
pcs_stonith__cib_pushed_cib_for_stonith:
  pcs.cib_pushed:
    - cibname: {{pcs.stonith_extra_cib}}
{% endif %}
