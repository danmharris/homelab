provider "postgresql" {
  host     = var.postgres_host
  port     = 5432
  username = "postgres"
  password = var.postgres_password
  sslmode  = "disable"
}

provider "sops" {}
