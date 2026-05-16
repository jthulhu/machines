{
  users = {
    mutableUsers = false;
    users = {
      adri = import ./adri.nix;
      marie = import ./marie.nix;
      # lol = import ./lol.nix;
      # mala = import ./mala.nix;
    };
  };
}
