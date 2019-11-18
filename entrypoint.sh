#!/bin/bash

for i in COCOS_BCX_DATABASE witness_node_data_dir; do
  mkdir -p /projects/$i
  cp -n /config.ini /projects/$i/config.ini
done
exec $*
