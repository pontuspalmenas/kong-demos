package main

import (
	"context"
	"fmt"
	"math/rand/v2"
	"net/http"
	"time"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

type Input struct {
}

type Output struct {
	Result int    `json:"result" jsonschema:"the result of the dice roll"`
	Debug  string `json:"debug" jsonschema:"the debug output of the dice roller"`
}

func RollTheDice(ctx context.Context, req *mcp.CallToolRequest, input Input) (*mcp.CallToolResult, Output, error) {

	return nil, Output{Result: rand.IntN(20), Debug: fmt.Sprintf("time: %s", time.Now().Format(time.RFC3339))}, nil
}

func main() {
	// Create a server with a single tool.
	server := mcp.NewServer(&mcp.Implementation{Name: "dice-roller", Version: "v1.0.0"}, nil)
	mcp.AddTool(server, &mcp.Tool{Name: "dice-roller", Description: "Roll a D20"}, RollTheDice)

	handler := mcp.NewStreamableHTTPHandler(
		func(*http.Request) *mcp.Server { return server },
		&mcp.StreamableHTTPOptions{},
	)

	http.HandleFunc("/mcp", handler.ServeHTTP)
	if err := http.ListenAndServe(":3001", nil); err != nil {
		panic(err)
	}
}
