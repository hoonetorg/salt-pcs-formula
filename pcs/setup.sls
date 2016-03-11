# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "pcs/map.jinja" import pcs with context %}

pcs_setup__setup:
  pcs.cluster_setup:
    - nodes: [ '{{pcs.admin_node}}' ]
    - pcsclustername: {{pcs.pcsclustername|default('pcscluster')}} 
    - extra_args: {{pcs.setup_extra_args|default([])}}

{% for node in pcs.nodes|sort %}
{% if node not in [ pcs.admin_node ] %}
pcs_setup__node_add_{{node}}:
  pcs.cluster_node_add:
    - node: {{node}}
    - extra_args: {{pcs.node_add_extra_args|default([])}}
{% endif %}
{% endfor %}
