#!/bin/sh

PUPPET_ROOT=/etc/puppet
puppet apply ${PUPPET_ROOT}/manifests/site.pp --modulepath=${PUPPET_ROOT}/environments/production/modules/ --hiera_config=hiera.yaml $*
