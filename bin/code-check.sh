#!/bin/bash

mix compile && \
  mix code.check && MIX_ENV=dev mix dialyzer --format raw

# SOMEBOLOW=$(mix sobelow -i Config.HTTPS,DOS.StringToAtom --compact)

# if [[ $SOMEBOLOW ]]; then
#   echo "${SOMEBOLOW}";
#   exit 1;
# else
#   mix code.check && MIX_ENV=dev mix dialyzer --format raw
# fi
