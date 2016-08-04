# -*- coding: utf-8 -*-
# vim: ft=sls

include:
  - pcs.install
  - pcs.service


extend:
  pcs_service__service:
    service:
      - require:
        - pkg: pcs_install__pkg
