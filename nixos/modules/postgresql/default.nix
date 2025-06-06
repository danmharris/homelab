{config, ...}: {
  environment.persistence."/nix/persist" = {
    directories = [
      {
        directory = config.services.postgresql.dataDir;
        user = "postgres";
        group = "postgres";
        mode = "0750";
      }
    ];
  };
}
