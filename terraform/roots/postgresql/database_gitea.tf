resource "postgresql_database" "gitea" {
  name = "gitea"
}

resource "postgresql_role" "gitea" {
  name     = "gitea"
  login    = true
  password = data.sops_file.credentials.data["gitea"]
}

resource "postgresql_grant" "gitea_all" {
  database    = postgresql_database.gitea.name
  role        = postgresql_role.gitea.name
  object_type = "database"
  privileges  = ["CREATE", "CONNECT", "TEMPORARY"]
}
