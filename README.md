# infra

Tools and templates to control the world (your tech stack) via handy scripts

## Kubernetes 

Find tools and examples to create your [kubernetes](https://kubernetes.com) deployments here

1. [Magician](./kubernetes/tools/magician) - Deploy one or more kubernetes apps to a cluster using a simple config
2. [Kubify](./kubernetes/tools/kubify) - Deploy a single app to a cluster using a config. Consider using the new magician tool instead of kubify
3. [Patchy](./kuberenetes/tools/patchy) - Deployments out of date? Use patchy to quick patch your apps without having to redeploy

See [examples](./kubernetes/examples)

## Docker

Find tools and examples to create your [docker](https://docker.com) deployments here

1. [Dockify](./docker/tools/dockify) - Generate a docker image for your app based on core runtime language (node, rust etc.)

To add more runtime languages, please create an issue and add them [here](./docker/tools/dockify/template)

See [examples](./docker/examples)

## NGINX

Find tools and examples to create your [NGINX](https://www.nginx.com/) deployments here

1. [Magician](./nginx/tools/magician) - Generate a root nginx config for your NGNIX servers

## Let's Encrypt Certbox [Experimental]

Find scripts and tools to manage your certificates via [certbot](https://certbot.eff.org/)

Use [certbot.sh](./letsencrypt-certbot/certbot.sh) to manage your cert

## Caddy [Experimental]

Find scripts and configs to manage your servers and https via [Caddy](https://caddyserver.com/)

Checkout [this folder](./caddy) to find some examples

