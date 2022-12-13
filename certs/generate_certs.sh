#!/bin/bash

ROOT_DN="/C=PL/ST=Malopolska/L=Krakow/O=Envoy Control Root Authority/"
INTERMEDIATE_DN="/C=PL/ST=Malopolska/L=Krakow/O=Envoy Control Intermediate Authority/"

function gen_root_ca {
  # Root key
  openssl genrsa -out "root-ca-$1.key" 2048

  # Self-sign root cert
  openssl req \
    -x509 \
    -new \
    -nodes \
    -key "root-ca-$1.key" \
    -days 99999 \
    -out "root-ca-$1.crt" \
    -subj "$ROOT_DN"
}

function gen_client {
  # Client key
  openssl genrsa -out "privkey-echo-$1.key" 2048

  # Client CSR
  openssl req -new \
    -key "privkey-echo-$1.key" \
    -out "echo-$1.csr" \
    -subj "/CN=$3/C=PL/"

  # Sign
  openssl x509 \
    -req -in "echo-$1.csr" \
    -extfile <(echo "subjectAltName=DNS:$3") \
    -CA "root-ca-$2.crt" \
    -CAkey "root-ca-$2.key" \
    -CAcreateserial \
    -days 99999 \
    -out "echo-$1-signed-by-root-ca-$2.crt"

  cat "echo-$1-signed-by-root-ca-$2.crt" > "fullchain-echo-$1.crt"
}

# gen_client 1 1 "echo-server.default.svc.cluster.local"
# gen_client 1 1 "echo-client.default.svc.cluster.local"
