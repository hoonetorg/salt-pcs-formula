# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "pcs/map.jinja" import pcs with context %}

{% if pcs.resources_cib is defined and pcs.resources_cib %}
pcs_resources__cib_created_{{pcs.resources_cib}}:
  pcs.cib_created:
    - cibname: {{pcs.resources_cib}}
{% endif %}

{% if 'resources' in pcs %}
{% for resource, resource_data in pcs.resources.items()|sort %}
pcs_resources__resource_created_{{resource}}:
  pcs.resource_created:
    - resource_id: {{resource}}
    - resource_type: "{{resource_data.resource_type}}"
    - resource_options: {{resource_data.resource_options|json}}
{% if pcs.resources_cib is defined and pcs.resources_cib %}
    - require:
      - pcs: pcs_resources__cib_created_{{pcs.resources_cib}}
    - require_in:
      - pcs: pcs_resources__cib_pushed_{{pcs.resources_cib}}
    - cibname: {{pcs.resources_cib}}
{% endif %}
{% endfor %}
{% endif %}

{% if 'constraints' in pcs %}
{% for constraint, constraint_data in pcs.constraints.items()|sort %}
pcs_resources__constraint_created_{{constraint}}:
  pcs.constraint_created:
    - constraint_id: {{constraint}}
    - constraint_type: "{{constraint_data.constraint_type}}"
    - constraint_options: {{constraint_data.constraint_options|json}}
{% if pcs.resources_cib is defined and pcs.resources_cib %}
    - require:
      - pcs: pcs_resources__cib_created_{{pcs.resources_cib}}
    - require_in:
      - pcs: pcs_resources__cib_pushed_{{pcs.resources_cib}}
    - cibname: {{pcs.resources_cib}}
{% endif %}
{% endfor %}
{% endif %}

{% if pcs.resources_cib is defined and pcs.resources_cib %}
pcs_resources__cib_pushed_{{pcs.resources_cib}}:
  pcs.cib_pushed:
    - cibname: {{pcs.resources_cib}}
{% endif %}
