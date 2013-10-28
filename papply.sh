#!/bin/sh

PUPPET_ROOT=./puppet
puppet apply ${PUPPET_ROOT}/manifests/site.pp --modulepath=${PUPPET_ROOT}/modules/ --hiera_config=hiera.yaml $*
