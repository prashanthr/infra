#/bin/bash
./scripts/setup-workspace.sh
./scripts/setup-docker.sh
./scripts/setup-nginx.sh
./scripts/setup-apps.sh
./scripts/copy-app-configs.sh
./scripts/boot-nginx.sh
