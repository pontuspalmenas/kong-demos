# Demo Kong AI GW with simple MCP

This repo shows how to configure Kong with a simple MCP server.
Uses Konnect, Kong AI Gateway, MCP Proxy Advanced, Docker compose, a custom MCP-server (dice-roller). 

### How to run
1. Update `certs/tls.crt`, `certs/tls.key`
2. Update `.env` and set `KONG_CLUSTER_PREFIX` to your cluster id from Konnect. This is used by Docker compose.
3. Run the Kong AI Gateway, `docker compose up -d`
4. Sync the state:
```
deck gateway sync kong.yaml \ 
  --konnect-token $KONNECT_TOKEN \
  --konnect-addr https://eu.api.konghq.com \
  --konnect-control-plane-name <your-control-plane-name>
```