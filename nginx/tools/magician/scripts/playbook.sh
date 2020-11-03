#/bin/bash
./scripts/setup-workspace.sh
./scripts/setup-docker.sh
./scripts/setup-nginx.sh
./scripts/cleanup-docker.sh
./scripts/install-apps.sh
./scripts/boot-nginx.sh
