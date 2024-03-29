resource "authentik_provider_oauth2" "nextcloud" {
  name               = "Nextcloud"
  client_id          = "7c29295fd7e35c03daf8e9e6145e6a55"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  client_secret      = data.sops_file.secrets.data["nextcloud"]
  redirect_uris      = ["https://nextcloud.dnhrrs.xyz/apps/sociallogin/custom_oidc/authentik"]
  property_mappings  = data.authentik_scope_mapping.default_scopes.ids
  signing_key        = data.authentik_certificate_key_pair.generated.id
}

resource "authentik_application" "nextcloud" {
  name              = "Nextcloud"
  slug              = "nextcloud"
  protocol_provider = authentik_provider_oauth2.nextcloud.id
}
