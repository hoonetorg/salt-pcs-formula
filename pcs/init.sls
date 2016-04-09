# -*- coding: utf-8 -*-
# vim: ft=sls

include:
  - pcs.install
  - pcs.user
  - pcs.service


extend:
  pcs_user__user:
    group:
      - require:
        - pkg: pcs_install__pkg
    user:
      - require:
        - pkg: pcs_install__pkg
  pcs_service__service:
    service:
      - watch:
        - group: pcs_user__user
        - user: pcs_user__user
      - require:
        - pkg: pcs_install__pkg
