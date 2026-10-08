#!/usr/bin/env bash
# End-to-end: MCP client -> AI GW /mcp -> API GW (Host: httpbin.example) -> httpbin
U=${U:-http://localhost:18010/mcp}
H='Content-Type: application/json'; A='Accept: application/json, text/event-stream'
SID=$(curl -si $U -H "$H" -H "$A" -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"t","version":"1"}}}' | awk -F': ' 'tolower($1)=="mcp-session-id"{print $2}' | tr -d '\r')
echo "session: $SID"
S="Mcp-Session-Id: $SID"
curl -s $U -H "$H" -H "$A" -H "$S" -d '{"jsonrpc":"2.0","method":"notifications/initialized"}' >/dev/null
echo "== tools/list"; curl -s $U -H "$H" -H "$A" -H "$S" -d '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
call(){ echo; echo "== $1"; curl -s $U -H "$H" -H "$A" -H "$S" -d "{\"jsonrpc\":\"2.0\",\"id\":3,\"method\":\"tools/call\",\"params\":{\"name\":\"$1\",\"arguments\":$2}}"; }
call httpbin_uuid '{}'
call httpbin_get '{"query_msg":"hello"}'
call httpbin_status '{"path_code":418}'
echo
