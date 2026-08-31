let
  rlyeh = "age13aza84d34mwd2aja37rw3uq00gk9d7yg7fl53g50496wxvx6ly5sk3xst5";
in {
  "pia-credentials.age" = {
    script = ''
      secrets=$(pass pia/login)
      username=$(echo "$secrets" | cut -d $'\n' -f 2)
      username=''${username#login: }
      password=$(echo "$secrets" | cut -d $'\n' -f 1)
      echo "$username"
      echo "$password"
    '';
    publicKeys = [
      rlyeh
    ];
  };
}
