# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "pcs/map.jinja" import pcs with context %}

# fix for debian
pcs_setup__file_/etc/corosync/uidgid.d:
  file.directory:
    - name: /etc/corosync/uidgid.d
    - ensure: present
    - makedirs: True
    - user: root
    - group: root
    - mode: '0755'

pcs_setup__setup:
  pcs.cluster_setup:
    - nodes: [ '{{pcs.admin_node_rings|default(pcs.admin_node)}}' ]
    - pcsclustername: {{pcs.pcsclustername|default('pcscluster')}} 
    - extra_args: {{pcs.setup_extra_args|default([])}}

{% for node in pcs.nodes_rings|default(pcs.nodes)|sort %}
{# if node not in [ pcs.admin_node_rings|default(pcs.admin_node) ] #}
pcs_setup__node_present_{{node}}:
  pcs.cluster_node_present:
    - node: {{node}}
    - extra_args: {{pcs.node_present_extra_args|default([])}}
{# endif #}
{% endfor %}
