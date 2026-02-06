package main

import "time"

type WeatherReport struct {
	Location struct {
		Name       string  `json:"name" jsonschema:"The name of the location"`
		Country    string  `json:"country" jsonschema:"The country of the location"`
		Lat        float64 `json:"lat" jsonschema:"The latitude of the location"`
		Lon        float64 `json:"lon" jsonschema:"The longitude of the location"`
		Timezone   string  `json:"timezone" jsonschema:"The timezone of the location"`
		ElevationM int     `json:"elevation_m" jsonschema:"The elevation measured"`
	} `json:"location" jsonschema:"The location for the weather forecast"`
	GeneratedAt time.Time `json:"generated_at"`
	Daily       []struct {
		Date    string `json:"date" jsonschema:"The date for the weather forecast"`
		Summary string `json:"summary" jsonschema:"The summary of the weather forecast"`
		Temp    struct {
			Min          float64 `json:"min" jsonschema:"The minimum temperature"`
			Max          float64 `json:"max" jsonschema:"The maximum temperature"`
			FeelsLikeMin float64 `json:"feels_like_min" jsonschema:"The minimum feels like"`
			FeelsLikeMax float64 `json:"feels_like_max" jsonschema:"The maximum feels like"`
		} `json:"temp" jsonschema:"The temperature of the weather forecast"`
		HumidityPct   int `json:"humidity_pct" jsonschema:"The humidity percent"`
		PressureHpa   int `json:"pressure_hpa" jsonschema:"The pressure hpa"`
		CloudCoverPct int `json:"cloud_cover_pct" jsonschema:"The cloud cover percent"`
		UvIndex       int `json:"uv_index" jsonschema:"The UV index"`
		Sun           struct {
			Sunrise time.Time `json:"sunrise" jsonschema:"The sunrise time"`
			Sunset  time.Time `json:"sunset" jsonschema:"The sunset time"`
		} `json:"sun" jsonschema:"The sun forecast"`
	} `json:"daily"`
}
