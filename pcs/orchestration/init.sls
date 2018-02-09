#!jinja|yaml
{% set node_ids = salt['pillar.get']('pcs:lookup:node_ids') -%}
{% set admin_node_id = salt['pillar.get']('pcs:lookup:admin_node_id') -%}

# node_ids: {{node_ids|json}}
# admin_node_id: {{admin_node_id}}

pcs_orchestration__install:
  salt.state:
    - tgt: {{node_ids|json}}
    - tgt_type: list
    - expect_minions: True
    - saltenv: {{saltenv}}
    - sls: pcs

pcs_orchestration__auth:
  salt.state:
    - tgt: {{admin_node_id}}
    - expect_minions: True
    - saltenv: {{saltenv}}
    - sls: pcs.auth
    - require:
      - salt: pcs_orchestration__install

pcs_orchestration__setup:
  salt.state:
    - tgt: {{admin_node_id}}
    - expect_minions: True
    - saltenv: {{saltenv}}
    - sls: pcs.setup
    - require:
      - salt: pcs_orchestration__auth

pcs_orchestration__properties:
  salt.state:
    - tgt: {{admin_node_id}}
    - expect_minions: True
    - saltenv: {{saltenv}}
    - sls: pcs.properties
    - require:
      - salt: pcs_orchestration__setup

pcs_orchestration__stonith:
  salt.state:
    - tgt: {{admin_node_id}}
    - expect_minions: True
    - saltenv: {{saltenv}}
    - sls: pcs.stonith
    - require:
      - salt: pcs_orchestration__properties

pcs_orchestration__resources:
  salt.state:
    - tgt: {{admin_node_id}}
    - expect_minions: True
    - saltenv: {{saltenv}}
    - sls: pcs.resources
    - require:
      - salt: pcs_orchestration__stonith
