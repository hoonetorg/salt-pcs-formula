# -*- coding: utf-8 -*-
'''
Manage pacemaker clusters with pcs
==================================

Example:

.. code-block:: yaml

    pcs_config__auth:
        pcs.auth:
          - nodes: 
            - node1.example.com
            - node2.example.com
          - pcsuser: hacluster
          - pcspasswd: hacluster
'''
from __future__ import absolute_import

# Import python libs
import logging

# Import salt libs
import salt.utils

log = logging.getLogger(__name__)


def __virtual__():
    '''
    Only load if pcs is installed.
    '''
    return salt.utils.which('pcs') is not None


def auth(name, nodes, pcsuser='hacluster', pcspasswd='hacluster', extra_args=[]):
    '''
    Ensure all nodes are authorized to the cluster

    name
        Irrelevant, not used (recommended: pcs_config__auth)
    nodes
        a list of nodes which should be authorized to the cluster
    pcsuser
        user for communitcation with pcs (default: hacluster)
    pcspasswd
        password for pcsuser (default: hacluster)
    extra_args
        list of extra option for the \'pcs auth\' command
    '''

    ret = {'name': name, 'result': True, 'comment': '', 'changes': {}}
    result = {}
    auth_required = False

    authorized  = __salt__['pcs.is_auth'](nodes=nodes)
    log.trace('Output of pcs.is_auth: ' + str(authorized))

    authorized_dict = {}
    for line in authorized['stdout'].splitlines():
      node = line.split(':')[0].strip()
      auth_state = line.split(':')[1].strip()
      if node in nodes:
        authorized_dict.update( { node : auth_state} )
    log.trace('authorized_dict: ' + str(authorized_dict))

    for node in nodes:
      if node in authorized_dict and authorized_dict[node] == 'Already authorized':
        ret['comment'] += 'Node {0} is already authorized\n'.format(node)
      else:
        auth_required = True
        if __opts__['test']:
          ret['comment'] += 'Node is set to authorize: {0}\n'.format(node)
    
    if not auth_required:
      return ret

    if __opts__['test']:
      ret['result'] = None
      return ret

    if '--force' not in extra_args:
      extra_args += [ '--force' ]
    authorize = __salt__['pcs.auth'](nodes=nodes, pcsuser=pcsuser, pcspasswd=pcspasswd, extra_args=extra_args)
    log.trace('Output of pcs.auth: ' + str(authorize))

    authorize_dict = {}
    for line in authorize['stdout'].splitlines():
      node = line.split(':')[0].strip()
      auth_state = line.split(':')[1].strip()
      if node in nodes:
        authorize_dict.update( { node : auth_state} )
    log.trace('authorize_dict: ' + str(authorize_dict))

    for node in nodes:
      if node in authorize_dict and authorize_dict[node] == 'Authorized':
        ret['comment'] += 'Authorized {0}\n'.format(node)
        ret['changes'].update({node: {'old': '', 'new': 'Authorized'}})
      else:
        ret['result'] = False
        ret['comment'] += 'Failed to authorize {0} with error {1}\nAuthorization check for node {0} returned: {2}'.format(node, authorize_dict[node], authorized_dict[node],)

    return ret
