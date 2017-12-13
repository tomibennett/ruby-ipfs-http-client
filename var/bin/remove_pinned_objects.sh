#!/usr/bin/env bash

pinned_objects=$(docker exec ipfs_daemon ipfs pin ls --type=recursive | cut -d ' ' -f 1)

[[ ${pinned_objects} ]] && docker exec ipfs_daemon ipfs pin rm ${pinned_objects}