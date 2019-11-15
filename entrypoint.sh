#!/bin/bash

for i in COCOS_BCX_DATABASE witness_node_data_dir; do
  cp -n /config.ini /$i/config.ini
done
exec $*
