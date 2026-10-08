# MCP conversion-listener: httpbin via Kong API GW, exposed by AI GW 2.2

Client -> AI GW 2.2 `/mcp` (ai-mcp-proxy, conversion-listener) -> Kong API GW 3.14 EE (separate DP, Host `httpbin.example`) -> httpbin. All DB-less.

## Run
1. Export `KONG_LICENSE_DATA=...`
2. `docker compose up -d`
3. `./test.sh` (initialize, tools/list, three tools/call).

Ports: API GW proxy 18000, admin 18001. AI GW proxy 18010, admin 18011.

## Gotchas
- Conversion-listener shares one Route for MCP and REST. Tool calls re-enter that Route and go to its Service, so the Service must be the real upstream (the API GW). A dummy Service URL gives 502 to 127.0.0.1:65535.
- `preserve_host: true` lets each tool's `host` (httpbin.example) reach the API GW, which routes on it.
- MCP argument names are prefixed by location: `query_msg`, `path_code`.
- Echo `Mcp-Session-Id` from `initialize` on every later request.
- Upstream non-2xx (e.g. 418) returns `isError: true`.
- `protocols: [http]` must be set on Routes (default is https).
