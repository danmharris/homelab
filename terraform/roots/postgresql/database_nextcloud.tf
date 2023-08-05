resource "postgresql_database" "nextcloud" {
  name = "nextcloud"
}

resource "postgresql_role" "nextcloud" {
  name     = "nextcloud"
  login    = true
  password = data.sops_file.credentials.data["nextcloud"]
}

resource "postgresql_grant" "nextcloud_all" {
  database    = postgresql_database.nextcloud.name
  role        = postgresql_role.nextcloud.name
  object_type = "database"
  privileges  = ["CREATE", "CONNECT", "TEMPORARY"]
}
