terraform {
  required_providers {
    konnect = {
      source  = "kong/konnect"
      version = "~> 1.0"
    }
  }
}

provider "konnect" {
  personal_access_token = var.pat
  server_url            = "https://${var.region}.api.konghq.com"
}

locals {
  project      = var.project
  environments = ["dev", "stage", "prod"]
}

# 1. Create Control Planes for each environment
resource "konnect_gateway_control_plane" "cp" {
  for_each = toset(local.environments)

  name         = "${local.project}-${each.key}-${var.region}"
  description  = "Control Plane for ${local.project} in ${each.key} environment"
  labels = {
    env:"${each.key}"
    org-unit:"${var.project}"
  }
  auth_type    = "pki_client_certs"
}

# 2. Create Admin Teams
resource "konnect_team" "admin_team" {
  for_each = toset(local.environments)

  name        = "${local.project}-${each.key}-admin"
  description = "Admin access for ${each.key} control plane"
}

# 3. Create Viewer Teams
resource "konnect_team" "viewer_team" {
  for_each = toset(local.environments)

  name        = "${local.project}-${each.key}-viewer"
  description = "Read-only access for ${each.key} control plane"
}

# 4. Assign Roles to Admin Teams
resource "konnect_team_role" "admin_role_assignment" {
  for_each = toset(local.environments)

  team_id    = konnect_team.admin_team[each.key].id
  role_name  = "Admin"
  entity_id  = konnect_gateway_control_plane.cp[each.key].id
  entity_type_name = "Control Planes"
  entity_region = var.region
}

# 5. Assign Roles to Viewer Teams
resource "konnect_team_role" "viewer_role_assignment" {
  for_each = toset(local.environments)

  team_id    = konnect_team.viewer_team[each.key].id
  role_name  = "Viewer"
  entity_id  = konnect_gateway_control_plane.cp[each.key].id
  entity_type_name = "Control Planes"
  entity_region = var.region
}

# 6. Create System Accounts per environment
resource "konnect_system_account" "sys_account" {
  for_each = toset(local.environments)

  name        = "${local.project}-${each.key}"
  description = "System account for automation in ${each.key}"
  konnect_managed = false
}
