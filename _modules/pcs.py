# -*- coding: utf-8 -*-
'''
Pcs Command Wrapper
========================

The pcs command is wrapped for specific functions

:depends: pcs
'''
from __future__ import absolute_import

# Import python libs
import os

# Import salt libs
import salt.utils


def __virtual__():
    '''
    Only load if pcs is installed
    '''
    if salt.utils.which('pcs'):
        return 'pcs'
    return False


def auth(nodes, pcsuser='hacluster', pcspasswd='hacluster', extra_args = []):
    '''
    Authorize nodes

    CLI Example:

    .. code-block:: bash

        salt '*' pcs.auth nodes='[ node1.example.org node2.example.org ]' \\
                          pcsuser='hacluster' \\
                          pcspasswd='hacluster' \\
                          extra_args=[ '--force' ]
    '''
    cmd =  [ 'pcs',  'cluster',  'auth'  ]

    if pcsuser:
      cmd +=  [ '-u', pcsuser ]

    if pcspasswd:
      cmd +=  [ '-p',  pcspasswd ]

    cmd += extra_args
    cmd += nodes

    return __salt__['cmd.run_all'](cmd, output_loglevel='trace', python_shell=False)

def is_auth(nodes):
    '''
    Check if nodes are already authorized

    CLI Example:

    .. code-block:: bash

        salt '*' pcs.is_auth nodes='[ node1.example.org node2.example.org ]' 
    '''
    cmd =  [ 'pcs',  'cluster',  'auth'  ]
    cmd += nodes

    return __salt__['cmd.run_all'](cmd, stdin='\n\n', output_loglevel='trace', python_shell=False)
