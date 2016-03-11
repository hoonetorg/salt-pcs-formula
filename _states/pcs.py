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
        Irrelevant, not used (recommended: pcs_auth__auth)
    nodes
        a list of nodes which should be authorized to the cluster
    pcsuser
        user for communitcation with pcs (default: hacluster)
    pcspasswd
        password for pcsuser (default: hacluster)
    extra_args
        list of extra option for the \'pcs cluster auth\' command
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
        if node in authorized_dict:
          ret['comment'] += 'Authorization check for node {0} returned: {1}\n'.format(node, authorized_dict[node],)
        if node in authorize_dict:
          ret['comment'] += 'Failed to authorize {0} with error {1}\n'.format(node, authorize_dict[node],) 

    return ret


def cluster_setup(name, nodes, pcsclustername='pcscluster', extra_args=[]):
    '''
    Setup Pacemaker cluster on nodes.
    Should be run on one cluster node only 
    (there may be races)

    name
        Irrelevant, not used (recommended: pcs_setup__setup)
    nodes
        a list of nodes which should be set up
    pcsclustername
        Name of the Pacemaker cluster
    extra_args
        list of extra option for the \'pcs cluster setup\' command
    '''

    ret = {'name': name, 'result': True, 'comment': '', 'changes': {}}
    result = {}
    setup_required = False

    config_show  = __salt__['pcs.config_show']()
    log.trace('Output of pcs.config_show: ' + str(config_show))

    for line in config_show['stdout'].splitlines():
      key = line.split(':')[0].strip()
      value = line.split(':')[1].strip()
      if key in [ 'Cluster Name' ] and value in [ pcsclustername ]:
        ret['comment'] += 'Node is already set up\n'
      else:
        setup_required = True
        if __opts__['test']:
          ret['comment'] += 'Node is set to set up\n'
    
    if not setup_required:
      return ret

    if __opts__['test']:
      ret['result'] = None
      return ret

    setup = __salt__['pcs.cluster_setup'](nodes=nodes, pcsclustername=pcsclustername, extra_args=extra_args)
    log.trace('Output of pcs.cluster_setup: ' + str(setup))

    setup_dict = {}
    for line in setup['stdout'].splitlines():
      log.trace('line: ' + line)
      log.trace('line.split(:).len: ' + str(len(line.split(':'))))
      if len(line.split(':')) in [ 2 ]:
        node = line.split(':')[0].strip()
        setup_state = line.split(':')[1].strip()
        if node in nodes:
          setup_dict.update( { node : setup_state} )
    log.trace('setup_dict: ' + str(setup_dict))

    for node in nodes:
      if node in setup_dict and setup_dict[node] in [ 'Succeeded', 'Success' ]:
        ret['comment'] += 'Set up {0}\n'.format(node)
        ret['changes'].update({node: {'old': '', 'new': 'Setup'}})
      else:
        ret['result'] = False
        ret['comment'] += 'Failed to setup {0}\n'.format(node)
        if node in setup_dict:
          ret['comment'] += '{0}: setup_dict: {1}\n'.format(node,setup_dict[node],)
        ret['comment'] += str(setup)

    return ret
