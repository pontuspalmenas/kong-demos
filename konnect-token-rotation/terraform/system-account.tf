resource "konnect_system_account" "demo" {
  name            = "demo-token-rotation"
  description     = "Demo System Account with token rotation"
  konnect_managed = false
}

resource "time_rotating" "rotate" {
  rotation_minutes = 60
}

resource "konnect_system_account_access_token" "demoaccesstoken" {
  name       = "TF Managed Token"
  expires_at = timeadd(time_rotating.rotate.rotation_rfc3339, "15m")
  account_id = konnect_system_account.demo.id
}

resource "konnect_system_account_role" "demorole" {
  entity_id        = "*"
  entity_region    = "eu"
  entity_type_name = "Control Planes"
  role_name        = "Viewer"
  account_id       = konnect_system_account.demo.id
}

output "token" {
  value = konnect_system_account_access_token.demoaccesstoken.token
  sensitive = true
}