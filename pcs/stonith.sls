# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "pcs/map.jinja" import pcs with context %}

{% for stonith_resource, stonith_resource_data in pcs.stonith_resources.items()|sort %}
pcs_stonith__create_{{stonith_resource}}:
  pcs.stonith_created:
    - stonith_id: {{stonith_resource_data.stonith_id}}
    - stonith_device_type: {{stonith_resource_data.stonith_device_type}}
    - stonith_device_options: {{stonith_resource_data.stonith_device_options}}
{% endfor %}
