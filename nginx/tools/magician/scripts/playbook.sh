#!/bin/bash
./scripts/pre-reqs.sh
./scripts/setup-docker.sh
./scripts/setup-nginx.sh
./scripts/cleanup-docker.sh
./scripts/install-apps.sh
./scripts/boot-nginx.sh
