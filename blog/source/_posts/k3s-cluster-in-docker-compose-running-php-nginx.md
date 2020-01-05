---
title: K3s Cluster in Docker-Compose Running PHP Nginx
date: 2020-01-04 23:38:30
categories: 
- Notes
- Web-hosting
tags: [Web-hosting, Tutorial, Kubernetes, Container]
sidebar: toc
copyright: true
comments: true
---

Run a K3s cluster in docker-compose with PHP + Nginx on 1 Gb, 1 vCPU server.

If anything goes wrong, read documents; check if the versions match (things are changing every day)

At the end of this page includes a list of things used as reference when writing.

# Table of Content

- [Table of Content](#table-of-content)
- [Environment](#environment)
- [Prerequisites](#prerequisites)
- [Set Up Directory](#set-up-directory)
- [Launch the Cluster using Docker-Compose](#launch-the-cluster-using-docker-compose)
- [Talk to the Cluster](#talk-to-the-cluster)
- [Create Cluster Configs](#create-cluster-configs)
  - [SSL Key](#ssl-key)
  - [Nginx Snippets](#nginx-snippets)
  - [Nginx Site](#nginx-site)
  - [PHP code](#php-code)
  - [PHP Resources](#php-resources)
  - [Nginx Resources](#nginx-resources)
- [Config and Run the Cluster](#config-and-run-the-cluster)
- [Result](#result)
- [Stop and Clean up](#stop-and-clean-up)
- [Conclusion and Thoughts](#conclusion-and-thoughts)
- [Future Works](#future-works)
- [Reference](#reference)

# Environment

* 1 GB Memory
* 1 vCPU
* 25 GB SSD
* Debian 10.2 on Digital Ocean Droplet

# Prerequisites

* docker
* docker-compose
* a domain if wish to use https (and certificates)

Try this to set up but
it's better/more stable/more compatible to use `iptables` at this moment (01/04/2020):

[Set Up Debian 10 Server on Digital Ocean](https://docs.snowme34.com/en/latest/reference/devops/set-up-debian-10-server-on-digital-ocean.html)

# Set Up Directory

Feel free to choose any work directory, but for the purpose of simplicity,
a directory owned by a non-root user in the root directory (`/`) will be used
for this task.

```bash
sudo mkdir -v /docker/
# replace with your non-root user name and group
# (default group name is the same as the user name)
sudo chown __NAME__:__GROUP__ /docker/
```

To make it easier to manage and run scripts, create a `bin` directory

* here it is under `/docker/`
* alternatively, put it under `~/`, some distribution will automatically append it to `$PATH`
  * (`$PATH` is a list of directories that the shell will use to look for commands/executables)
* editing the `$PATH` variable is optional
  * it makes calling the script the same as calling normal commands

```bash
mkdir -v /docker/bin/

# pre-pend it to PATH, making the search end earlier
echo "PATH=/docker/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
```

It doesn't hurt to create several sub-directories for:

* Kubernetes resource yaml files
* volumes to mount

```bash
mkdir -v /docker/k3s
mkdir -v /docker/kube

# this directory holds the PHP code, i.e. the index.php
# explained later
mkdir -v /docker/www
```

# Launch the Cluster using Docker-Compose

As easy as one simple docker-compile file from [k3s official repo](https://github.com/rancher/k3s/blob/master/docker-compose.yml)

Modifications:

* rename services
* disable `traefik` by `--no-deploy traefik`
* mount directory with kubeconfig to host's `./k3s` (created above)
* mount php-code directory to container's `/var/www`
* open 80 and 443 (http/https) port for agents

```yaml
# to run define K3S_TOKEN, K3S_VERSION is optional, eg:
#   K3S_TOKEN=${RANDOM}${RANDOM}${RANDOM} docker-compose up

version: '3' 
services:

  k3s-server:
    image: "rancher/k3s:${K3S_VERSION:-latest}"
    command: server --no-deploy traefik
    tmpfs:
    - /run
    - /var/run
    privileged: true
    environment:
    - K3S_TOKEN=${K3S_TOKEN:?err}
    - K3S_KUBECONFIG_OUTPUT=/output/kubeconfig.yaml
    - K3S_KUBECONFIG_MODE=666
    volumes:
    - k3s-server:/var/lib/rancher/k3s
    # This is just so that we get the kubeconfig file out
    - ./k3s:/output
    - /docker/www:/var/www
    ports:
    - 6443:6443

  k3s-agent:
    image: "rancher/k3s:${K3S_VERSION:-latest}"
    tmpfs:
    - /run
    - /var/run
    privileged: true
    environment:
    - K3S_URL=https://k3s-server:6443
    - K3S_TOKEN=${K3S_TOKEN:?err}
    volumes:
    - /docker/www:/var/www
    ports:
    - 80:80
    - 443:443

volumes:
  k3s-server: {}
```

Let's create a script to run it:

```bash
touch /docker/bin/k3s-up.sh
chmod u+x /docker/bin/k3s-up.sh
```

Inside the up script:

```bash
#!/bin/bash

# feel free to change this
export K3S_TOKEN=${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}

echo "K3S_TOKEN: ${K3S_TOKEN}"
# might want to store token somewhere, e.g.
#echo ${K3S_TOKEN} > ~/.token/K3S_TOKEN

docker-compose -f /docker/docker-compose.yml up -d --scale k3s-agent="${1:-1}"
```

Now we just need to run this script

* since the directory is in `$PATH`, we can call it directly
* it creates 1 agent by default, can change it by providing command line argument

```bash
k3s-up.sh    # spawn 1 agents
#k3s-up.sh 3 # spawn 3 agents
```

Due to extreme memory constrain, let's begin with 1 agent

# Talk to the Cluster

Now the k3s cluster is up and running.

The system might go through a short thrashing period but it will settle down soon (tested on real machine).

It's time to `kubectl`. Let's use the `$KUBECONFIG` variable to simplify things:

```bash
export KUBECONFIG=/docker/k3s/kubeconfig.yaml
```

Might as well add this line to bashrc (optional):

* so that current user's shell will automatically set KUBECONFIG variable

```bash
echo "export KUBECONFIG=/docker/k3s/kubeconfig.yaml" >> ~/.bashrc
```

Test connection

```bash
kubectl get nodes
kubectl get pods --all-namespaces
```

If not working, consult `docker` and other logs

```bash
docker ps
docker logs
...
```

# Create Cluster Configs

Attempts to use nginx ingress have been made in vain because of
the limited resources.

We shall use our own nginx, plus [load balancer service provided by `k3s`](https://rancher.com/docs/k3s/latest/en/networking/#service-load-balancer) (good to be simple for simple tasks).

Start with the config maps:

* note: provided nginx configs may not suit every one's need

```bash
mkdir /docker/kube/config-nginx-key      # SSL key, if intend to use https
mkdir /docker/kube/config-nginx-sites    # nginx config for each site
mkdir /docker/kube/config-nginx-snippets # re-useable snippets
```

Let's go through each config file

## SSL Key

(If not using https, skip this step)

Files in `/docker/kube/config-nginx-key`:

```bash
# SSL certificates
origin.pem
private.pem

# Diffie-Hellman parameters
# https://wiki.openssl.org/index.php/Diffie-Hellman_parameters
dhparam.pem # openssl dhparam -out ./dhparam.pem 4096
```

For security reasons, my own SSL certificates will not be included here.

* because I use Cloudflare, my cluster uses [Cloudflare Origin CA certificates](https://support.cloudflare.com/hc/en-us/articles/115000479507-Managing-Cloudflare-Origin-CA-certificates)
* Also it does not require complex verification, renewal steps etc.
* If not suitable, might consider [a cert manager](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes#step-4-%E2%80%94-installing-and-configuring-cert-manager) (linked article uses ingress)

## Nginx Snippets

Files in `/docker/kube/config-nginx-snippets`:

```bash
ssl-some.host.conf
ssl-params.conf
restrictions.conf
```

ssl-some.host.conf

* just telling nginx which certificates to use

```conf
ssl_certificate     /etc/nginx/ssl-key/origin.pem;
ssl_certificate_key /etc/nginx/ssl-key/private.pem;
```

ssl-params.conf

* [cipherli.st](https://cipherli.st/)
* [String SSL Security On Nginx](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html)
* [Security/Server Side TLS - MozillaWiki](https://wiki.mozilla.org/Security/Server_Side_TLS)
* also if you are using Cloudflare like I do, end-users may see changed SSL headers etc.
  * since clients are talking to Cloudflare, not the host machine directly in general cases

```conf
# reference:
## https://cipherli.st/
## https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html
## https://github.com/h5bp/server-configs-nginx
## other online search results

# disable old or less secure protocols such as SSL3.0
ssl_protocols TLSv1.2 TLSv1.3; # v1.3 Requires nginx >= 1.13.0 else use TLSv1.2

# ciphers chosen for forward secrecy and compatibility
# http://blog.ivanristic.com/2013/08/configuring-apache-nginx-and-openssl-for-forward-secrecy.html
# https://github.com/h5bp/server-configs-nginx/blob/master/h5bp/ssl/policy_intermediate.conf
# https://wiki.mozilla.org/Security/Server_Side_TLS
# might need to change case-by-case
ssl_ciphers "TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:EECDH+CHACHA20:EECDH+AES;";

# enables server-side protection from BEAST attacks
# http://blog.ivanristic.com/2013/09/is-beast-still-a-threat.html
# **not** sure if still good choice
ssl_prefer_server_ciphers on;

# enable session resumption to improve https performance
# http://vincent.bernat.im/en/blog/2011-ssl-session-reuse-rfc5077.html
ssl_session_cache shared:SSL:10m;
ssl_session_timeout 24h;

# https://github.com/mozilla/server-side-tls/issues/135
ssl_session_tickets off;

# HSTS (HTTP Strict Transport Security)
# tell browsers to connect exclusively using https, cache the certificates; do so including sub-domains
add_header Strict-Transport-Security "max-age=63072000; includeSubDomains";

# enable ocsp stapling
# (mechanism by which a site can convey certificate revocation information to visitors in a privacy-preserving, scalable manner)
# http://blog.mozilla.org/security/2013/07/29/ocsp-stapling-in-firefox/
ssl_stapling on;
ssl_stapling_verify on;
resolver
  1.1.1.1 1.0.0.1 [2606:4700:4700::1111] [2606:4700:4700::1001]
  8.8.8.8 8.8.4.4 [2001:4860:4860::8888] [2001:4860:4860::8844]
  valid=300s;
resolver_timeout 5s;

# Diffie-Hellman parameter for DHE ciphersuites
# **requires manual generating pem file**
ssl_dhparam /etc/nginx/ssl-key/dhparam.pem;

# optional since nginx has good enough defaults
# https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_ecdh_curve
#ssl_ecdh_curve secp384r1;
```

restrictions.conf

```conf
# reference
## https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/#passing-uncontrolled-requests-to-php
## http://nginx.org/en/docs/http/ngx_http_core_module.html#location

# Global restrictions configuration file
# Designed to be included in any server {} block.

location = /favicon.ico {
    log_not_found off;
    access_log off;
}

location = /robots.txt {
    allow all;
    log_not_found off;
    access_log off;
}

# Deny all attempts to access hidden files such as .htaccess, .htpasswd, .DS_Store (Mac).
# Keep logging the requests to parse later (or to pass to firewall utilities such as fail2ban)
location ~ /\. {
    deny all;
}

# some security

# MIME type sniffing
add_header X-Content-Type-Options nosniff;

# tells IE to enable some filter
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-XSS-Protection
add_header X-XSS-Protection "1; mode=block";

# whether or not browsers are allowed to render pages in frame/iframe
# might **need updates**
add_header X-Frame-Options DENY;
# add_header X-Frame-Options some-good-origins;
```

## Nginx Site

```bash
/docker/kube/config-nginx-sites/php.conf
```

Inspired by:

* [PHP FastCGI Example](https://www.nginx.com/resources/wiki/start/topics/examples/phpfcgi/)
* [How To Deploy a PHP Application with Kubernetes on Ubuntu 18.04 | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-deploy-a-php-application-with-kubernetes-on-ubuntu-18-04#step-5-%E2%80%94-creating-the-nginx-deployment)

Choose one of the below:

* http

```conf
server {
  index index.php index.html;
  root /var/www;

  location / {
      try_files $uri $uri/ /index.php?$query_string;
  }

  location ~ \.php$ {
      try_files $uri =404;
      fastcgi_split_path_info ^(.+\.php)(/.+)$;
      fastcgi_pass kube-php:9000;
      fastcgi_index index.php;
      include fastcgi_params;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      fastcgi_param PATH_INFO $fastcgi_path_info;
    }
}
```

* https

```conf
server {
  listen 443 ssl http2;
  listen [::]:443 ssl http2;

  include /etc/nginx/snippets/ssl-some.host.conf;
  include /etc/nginx/snippets/ssl-params.conf;

  root /var/www;
  index  index.html  index.php;
  server_name some.host; # change to your own host name

  include /etc/nginx/snippets/restrictions.conf;

  location ~ [^/]\.php(/|$) {
    fastcgi_split_path_info ^(.+?\.php)(/.*)$;
    if (!-f $document_root$fastcgi_script_name) {
        return 404;
    }
    # Mitigate https://httpoxy.org/ vulnerabilities
    fastcgi_param HTTP_PROXY "";
    fastcgi_pass kube-php:9000;
    fastcgi_index index.php;
    include fastcgi_params;
    fastcgi_param  SCRIPT_FILENAME   $document_root$fastcgi_script_name;
  }
}
```

---

Back to our kubernetes cluster, now we need to create:

* PHP code
* PHP service
* PHP deployment
* nginx service LoadBalancer
* nginx deployment

```bash
mkdir -v /docker/kube/objects
```

Will use one file for related resources

## PHP code

For simplicity, the PHP code is directly put into `/docker/www`

Sample PHP file, put to `/docker/www/index.php`:

```php
<?php
echo phpinfo();
```

## PHP Resources

```bash
editor /docker/kube/objects/php.yaml
```

Inside the yaml:

* it exposes port 9000 via ClusterIP (default networking for service) for php-fpm
* php:7-fpm image is used
* the php code directory mounted earlier, `/var/www`, is mounted as a `hostPath` volume
  * generally **not** something desired in production
  * A possibly related [link](https://stackoverflow.com/questions/46738296/multiple-kubernetes-pods-sharing-the-same-host-path-pvc-will-duplicate-output) and [another](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/scheduling/resources.md).
  * might consider a kubernetes init container to set up the code etc.


```yaml
apiVersion: v1
kind: Service
metadata:
  name: kube-php
  labels:
    tier: backend
spec:
  ports:
  - protocol: TCP 
    port: 9000
  selector:
    app: kube-php
    tier: backend
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kube-php
  labels:
    tier: backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kube-php
      tier: backend
  template:
    metadata:
      labels:
        app: kube-php
        tier: backend
    spec:
      containers:
      - name: php 
        image: php:7-fpm
        volumeMounts:
        - name: www
          mountPath: /var/www
      volumes:
      - name: www
        hostPath:
          path: /var/www
          type: Directory
```

## Nginx Resources

```bash
editor /docker/kube/objects/nginx.yaml
```

Inside the yaml:

* a LoadBalancer service is created with port 80 and 443
  * thanks to k3s's networking, normally a bare-mental kubernetes cannot use LoadBalancer services
  * (["LoadBalancer services ... points to external load balancers that are NOT in your cluster"](https://stackoverflow.com/questions/45079988/ingress-vs-load-balancer))
* a deployment is created using nginx:1.16 image
  * a naive and simple approach to test the config online is included
  * the config maps to be created are mounted as directories
* about nginx conf:
  * nginx will automatically load conf in `/etc/nginx/conf.d`
  * for our case, our php.conf will include all other config files

```yaml
apiVersion: v1
kind: Service
metadata:
  name: kube-nginx
  labels:
    tier: backend
spec:
  type: LoadBalancer
  ports:
  - protocol: TCP
    port: 80
    name: http
  - protocol: TCP
    port: 443
    name: https
  selector:
    app: kube-nginx
    tier: backend
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kube-nginx
  labels:
    tier: backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kube-nginx
      tier: backend
  template:
    metadata:
      labels:
        app: kube-nginx
        tier: backend
    spec:
      containers:
      - name: nginx
        image: nginx:1.16
        ## uncomment this to test the nginx config
        ## use something like `kubectl logs kube-nginx-...` to see the output
        ## use `kubectl delete deployment ...` to remove the test deployment
        #command: ["/bin/bash","-c"]
        #args: ["echo testing-nginx-conf; nginx -t; sleep 10h"]
        ports:
        - containerPort: 80
        - containerPort: 443
        volumeMounts:
        - name: nginx-key
          mountPath: /etc/nginx/ssl-key
        - name: nginx-snippets
          mountPath: /etc/nginx/snippets
        - name: nginx-sites
          mountPath: /etc/nginx/conf.d
        - name: www
          mountPath: /var/www
      volumes:
      - name: nginx-key
        configMap:
          name: config-nginx-key
      - name: nginx-snippets
        configMap:
          name: config-nginx-snippets
      - name: nginx-sites
        configMap:
          name: config-nginx-sites
      - name: www
        hostPath:
          path: /var/www
          type: Directory
```

# Config and Run the Cluster

Now we have both the configs and the Kubernetes resources files ready.

Just a short script will do all the setup

```bash
touch /docker/bin/k3s-setup.sh
chmod u+x /docker/bin/k3s-setup.sh
```

Inside the setup script

```bash
#!/bin/bash

# ensure the config works
export KUBECONFIG=/docker/k3s/kubeconfig.yaml

set -e

# test connection (optional)
kubectl get node

# nginx config
kubectl create configmap config-nginx-key      --from-file=/docker/kube/config_nginx-key
kubectl create configmap config-nginx-snippets --from-file=/docker/kube/config_nginx-snippets
kubectl create configmap config-nginx-sites    --from-file=/docker/kube/config_nginx-sites

# apply 
kubectl apply -f /docker/kube/objects
```

Run the script

```bash
k3s-setup.sh
```

# Result

The whole server might suffer from a short period of thrashing after starting everything.

Assume all firewall, certificates and so forth all set up, go to `http://host-ip` or `https://some.host` (depend on your choice).

The PHP application will show up.

# Stop and Clean up

If encounter errors in the previous steps, or need a graceful shutdown,
here is a nothing-left-behind clean up script.

```bash
touch /docker/bin/k3s-down.sh
chmod u+x /docker/bin/k3s-down.sh
```

Inside the down script:

* shut down via docker-compose
* remove the used master server volume

```bash
# the existence of this variable is required by the docker-compose file
export K3S_TOKEN=NOTHING
# if you want the original token, might consider storing it somewhere, e.g.
#export K3S_TOKEN=$(cat ~/.token/K3S_TOKEN)

docker-compose -f /docker/docker-compose.yml down -v

# optional, delete the no-longer-valid kubeconfig
rm -f /docker/k3s/kubeconfig.yaml
#might remove the saved K3S_TOKEN as well
```

# Conclusion and Thoughts

The purpose of Kubernetes is not, clearly, doing things like this.

But the k3s cluster created is perfect for dev and testing, especially for single-machine.
And it's fun to run a fully-functional Kubernetes on the cutest VPS!

# Future Works

* make the cluster persistent
  * currently cleaning everything up
  * might use `docker-compose stop`, but ideally only the master data is needed
  * potentially related: [How to make a full backup of  k3s server's data? · Issue #927 · rancher/k3s](https://github.com/rancher/k3s/issues/927)

# Reference

Some of documents/tutorials are not updated or no longer working.

Tutorials

* [How To Deploy a PHP Application with Kubernetes on Ubuntu 18.04 | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-deploy-a-php-application-with-kubernetes-on-ubuntu-18-04)
* [How to Set Up an Nginx Ingress with Cert-Manager on DigitalOcean Kubernetes | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes)
* [docker-composeでK3sを試してみた - Qiita](https://qiita.com/Tei1988/items/0ef7dfba11497696bf56)
* [Single node Kubernetes setup – /techblog](https://www.redpill-linpro.com/techblog/2019/04/04/kubernetes-setup.html)
* [How To Create a Kubernetes Cluster Using Kubeadm on Ubuntu 18.04 | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-create-a-kubernetes-cluster-using-kubeadm-on-ubuntu-18-04)

K3s

* [Installation Options](https://rancher.com/docs/k3s/latest/en/installation/install-options/)
* [Networking](https://rancher.com/docs/k3s/latest/en/networking/)
* [Advanced Options and Configuration](https://rancher.com/docs/k3s/latest/en/advanced/)
* [Volumes and Storage](https://rancher.com/docs/k3s/latest/en/storage/)
* [local-path-provisioner/README.md at master · rancher/local-path-provisioner](https://github.com/rancher/local-path-provisioner/blob/master/README.md#usage)

Kubernetes

* [K3s, minikube or microk8s? : kubernetes](https://www.reddit.com/r/kubernetes/comments/be0415/k3s_minikube_or_microk8s/)
* [Resources + Controllers Overview · The Kubectl Book](https://kubectl.docs.kubernetes.io/pages/kubectl_book/resources_and_controllers.html)
* [Debug Pod Replication Controller - Kubernetes](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-pod-replication-controller/)
* [Creating a single control-plane cluster with kubeadm - Kubernetes](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

Kubernetes Volumes

* [Volumes - Kubernetes](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath) hostPath
* [Configure a Pod to Use a ConfigMap - Kubernetes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#add-configmap-data-to-a-volume)
* [Persistent Volumes - Kubernetes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#claims-as-volumes)
* [Kubernetes 1.14: Local Persistent Volumes GA - Kubernetes](https://kubernetes.io/blog/2019/04/04/kubernetes-1.14-local-persistent-volumes-ga/)
* [Storage Classes - Kubernetes](https://kubernetes.io/docs/concepts/storage/storage-classes/#local) local
* [community/resources.md at master · kubernetes/community](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/scheduling/resources.md)

Kubernetes Networking

* [Ingress vs Load Balancer](https://stackoverflow.com/questions/45079988/ingress-vs-load-balancer)
* [Ingress - Kubernetes](https://kubernetes.io/docs/concepts/services-networking/ingress/#alternatives)
* [Bare-metal considerations - NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/deploy/baremetal/)
* [Exposing FCGI services - NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/user-guide/fcgi-services/)
* [symfony - NGINX - PHP-FPM multiple application K8s/Ingress - Stack Overflow](https://stackoverflow.com/questions/52041010/nginx-php-fpm-multiple-application-k8s-ingress)
* [ingress-nginx/docs/examples/multi-tls at master · kubernetes/ingress-nginx](https://github.com/kubernetes/ingress-nginx/tree/master/docs/examples/multi-tls)

Nginx config

* [Strong SSL Security on nginx - Raymii.org](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html)
* [h5bp/server-configs-nginx: Nginx HTTP server boilerplate configs](https://github.com/h5bp/server-configs-nginx)
* [Remove deprecated ciphers and protocols by aeris · Pull Request #190 · h5bp/server-configs-nginx](https://github.com/h5bp/server-configs-nginx/pull/190#issuecomment-367843852)
* [Use modern SSL config for Nginx by swalkinshaw · Pull Request #1127 · roots/trellis](https://github.com/roots/trellis/pull/1127)
* [Security/Server Side TLS - MozillaWiki](https://wiki.mozilla.org/Security/Server_Side_TLS)
* [CryptCheck](https://cryptcheck.fr/suite/)
