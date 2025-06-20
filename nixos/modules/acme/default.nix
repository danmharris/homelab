{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.acme;
in {
  options.mySystem.acme.enable = lib.mkEnableOption "acme";

  config = lib.mkIf (cfg.enable) {
    sops.secrets = {
      "security/acme/cloudflare_token".sopsFile = ./secrets.yml;
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "admin@dnhrrs.xyz";
      certs."dnhrrs.xyz" = {
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        extraDomainNames = [
          "dnhrrs.xyz"
          "*.dnhrrs.xyz"
        ];
        credentialFiles = {
          "CLOUDFLARE_DNS_API_TOKEN_FILE" = config.sops.secrets."security/acme/cloudflare_token".path;
        };
      };
    };

    environment.persistence."/nix/persist" = {
      directories = ["/var/lib/acme"];
    };
  };
}
