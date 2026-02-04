variable pat {
  description = "Konnect Personal Access Token"
  type = string
  sensitive = true
}

variable region {
  description = "Konnect Default Region"
  type = string
}

variable project {
    description = "Project Name"
    type = string
    default = "demo"
}