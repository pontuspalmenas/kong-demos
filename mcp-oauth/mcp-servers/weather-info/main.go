package main

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"os"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

type Input struct {
}

func readWeather(premium bool) (WeatherReport, error) {
	var path string
	if premium {
		path = "data/weather-premium.json"
	} else {
		path = "data/weather-basic.json"
	}
	bs, err := os.ReadFile(path)
	if err != nil {
		return WeatherReport{}, err
	}
	var weatherReport WeatherReport
	err = json.Unmarshal(bs, &weatherReport)
	if err != nil {
		return WeatherReport{}, err
	}
	return weatherReport, nil
}

func GetWeatherSecure(ctx context.Context, req *mcp.CallToolRequest, input Input, scopes []string) (*mcp.CallToolResult, any, error) {
	r, err := readWeather(false)
	if err != nil {
		return nil, nil, err
	}

	return nil, r, nil

	/*return &mcp.CallToolResult{
		IsError: false,
		Content: []mcp.Content{
			&mcp.TextContent{Text: fmt.Sprintf("Debug: %s", time.Now().Format(time.RFC3339))},
		},
	}, r, nil*/
}

func main() {
	handler := mcp.NewStreamableHTTPHandler(
		func(r *http.Request) *mcp.Server {
			fmt.Printf("Headers: %+v\n", r.Header)
			scopes := r.Header["X-Authenticated-Scope"]

			server := mcp.NewServer(&mcp.Implementation{Name: "weather-info"}, nil)

			mcp.AddTool(
				server, &mcp.Tool{Name: "weather-info", Description: "Get weather forecast"},
				func(ctx context.Context, req *mcp.CallToolRequest, input Input) (*mcp.CallToolResult, any, error) {
					return GetWeatherSecure(ctx, req, input, scopes)
				})

			return server
		},
		&mcp.StreamableHTTPOptions{},
	)

	http.HandleFunc("/", handler.ServeHTTP)
	if err := http.ListenAndServe(":3002", nil); err != nil {
		panic(err)
	}
}
