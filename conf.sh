#!/bin/bash
set -Eeuo pipefail

cat >> ${PGDATA}/postgresql.conf << EOT
listen_addresses = '*'
EOT
