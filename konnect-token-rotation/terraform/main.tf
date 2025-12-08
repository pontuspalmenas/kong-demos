terraform {
  required_providers {
    konnect = {
      source  = "kong/konnect"
    }
  }
}

provider "konnect" {
  personal_access_token = var.pat
  server_url            = "https://eu.api.konghq.com"
}