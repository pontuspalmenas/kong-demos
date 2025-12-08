#!/bin/bash

mkdir -p ./certs

# 1. Create CA
openssl genrsa -out certs/kong_clustering_ca.key 4096
openssl req -x509 -new -nodes -key certs/kong_clustering_ca.key \
  -sha256 -days 1825 -out certs/kong_clustering_ca.crt \
  -subj "/C=US/ST=California/L=San Francisco/O=Kong Clustering Testing/CN=kong_clustering_ca"

# 2. Create CP cert signed by CA
# Generate key and CSR
openssl genrsa -out certs/kong_clustering.key 4096
openssl req -new -key certs/kong_clustering.key \
  -out certs/kong_clustering.csr \
  -subj "/C=US/ST=California/L=San Francisco/O=Kong Clustering Testing/CN=kong_clustering"

# Sign the CSR with the CA
openssl x509 -req -in certs/kong_clustering.csr \
  -CA certs/kong_clustering_ca.crt -CAkey certs/kong_clustering_ca.key -CAcreateserial \
  -out certs/kong_clustering.crt -days 825 -sha256 \
  -extfile <(echo "subjectAltName=DNS:kong_clustering,DNS:kong-cp-kong-cluster.kong.svc.cluster.local")

# 3. Create DP cert signed by CA
openssl genrsa -out certs/kong_clustering_client.key 4096
openssl req -new -key certs/kong_clustering_client.key \
  -out certs/kong_clustering_client.csr \
  -subj "/C=US/ST=California/L=San Francisco/O=Kong Clustering Testing/CN=kong_clustering_client"
openssl x509 -req -in certs/kong_clustering_client.csr \
  -CA certs/kong_clustering_ca.crt -CAkey certs/kong_clustering_ca.key -CAcreateserial \
  -out certs/kong_clustering_client.crt -days 825 -sha256 \
  -extfile <(echo "subjectAltName=DNS:kong_clustering_client")

# 4. Create upstream cert signed by CA
openssl genrsa -out certs/httpbin.key 2048
openssl req -new -key certs/httpbin.key \
  -out certs/httpbin.csr \
  -subj "/CN=httpbin.kong.svc.cluster.local"
openssl x509 -req -in certs/httpbin.csr \
  -CA certs/kong_clustering_ca.crt \
  -CAkey certs/kong_clustering_ca.key \
  -CAcreateserial -out certs/httpbin.crt \
  -days 365 -sha256 \
  -extfile <(echo "subjectAltName=DNS:httpbin.kong.svc.cluster.local")  

# 4. Verify
openssl verify -CAfile certs/kong_clustering_ca.crt certs/kong_clustering.crt
openssl verify -CAfile certs/kong_clustering_ca.crt certs/kong_clustering_client.crt
openssl verify -CAfile certs/kong_clustering_ca.crt certs/httpbin.crt