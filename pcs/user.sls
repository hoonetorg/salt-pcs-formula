# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "pcs/map.jinja" import pcs with context %}

pcs_user__user:
  group.present:
    - name: {{pcs.pcsgroup|default('haclient')}}
    - gid: {{pcs.pcsgid|default('189')}}
  user.present:
    - name: {{pcs.pcsuser|default('hacluster')}}
    - home: /home/hacluster
    - createhome: False
    - shell: /sbin/nologin
    - uid: {{pcs.pcsuid|default('189')}}
    - password: {{pcs.pcspasswd_hash|default('$6$nuCKI4DU$GWDxbqjbGK3uHPmVUflG3cu4FuekjYowWoM4K3t5JHaFNySlKO2W8ueL8Tbs6hgRovCm5OlHVxZMe9SsuApmC1')}}
    - enforce_password: True
    - gid: {{pcs.pcsgid|default('189')}}
    - remove_groups: False
    - groups:
      - {{pcs.pcsgroup|default('haclient')}}
    - require:
      - group: pcs_user__user
