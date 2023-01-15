resource "postgresql_database" "authentik" {
  name = "authentik"
}

resource "postgresql_role" "authentik" {
  name     = "authentik"
  login    = true
  password = data.sops_file.credentials.data["authentik"]
}

resource "postgresql_grant" "authentik_all" {
  database    = postgresql_database.authentik.name
  role        = postgresql_role.authentik.name
  object_type = "database"
  privileges  = ["CREATE", "CONNECT", "TEMPORARY"]
}
