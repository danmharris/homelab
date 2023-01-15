resource "postgresql_database" "woodpecker" {
  name = "woodpecker"
}

resource "postgresql_role" "woodpecker" {
  name     = "woodpecker"
  login    = true
  password = data.sops_file.credentials.data["woodpecker"]
}

resource "postgresql_grant" "woodpecker_all" {
  database    = postgresql_database.woodpecker.name
  role        = postgresql_role.woodpecker.name
  object_type = "database"
  privileges  = ["CREATE", "CONNECT", "TEMPORARY"]
}
