#!/bin/sh

PUPPET_ROOT=/etc/puppet
puppet apply ${PUPPET_ROOT}/manifests/site.pp --modulepath=${PUPPET_ROOT}/common-modules/:${PUPPET_ROOT}/modules/ --hiera_config=hiera.yaml $*
