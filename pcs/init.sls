# -*- coding: utf-8 -*-
# vim: ft=sls

include:
  - pcs.user
  - pcs.install
  - pcs.service


extend:
  pcs_install__pkg:
    pkg:
      - require:
        - group: pcs_user__user
        - user: pcs_user__user
  pcs_service__service:
    service:
      - require:
        - pkg: pcs_install__pkg
