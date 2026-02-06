# MCP OAuth Demo

This project demonstrates serving Model Context Protocol (MCP) servers behind Kong Gateway, showcasing both public and OAuth-protected endpoints.

## Components
- **Kong Gateway**: Manages traffic, enforcing OAuth2 on the weather service.
- **Keycloak**: Identity Provider for OAuth2 token issuance and introspection.
- **MCP Servers**: Two Go-based servers (`dice-roller` and `weather-info`).

## Quick Start
1. Create a `.env` file with your `KONNECT_TOKEN` and `KONNECT_CONTROL_PLANE_NAME`.
2. Add certificates (`tls.crt`, `tls.key`) in the `certs/` directory.
3.  **Run**: `docker compose up -d` to start Kong, Keycloak, and the MCP servers.
4.  **Sync**: Run `task deck-sync` to push the configuration (`kong.yaml`) to Konnect.

Use the `/mcp/dice` endpoint for public access and `/mcp/weather` for OAuth-protected access.

## Credentials
Keycloak is prepared with an OAuth client (`mcp-client`). Use the user credentials to login when prompted: `mcp-user`:`mcp-password`