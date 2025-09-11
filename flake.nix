{
  description = "Yoke's Nix flake templates";

  outputs = {...}: {
    templates = {
      blank = {
        path = ./templates/blank;
      };
      go = {
        path = ./templates/go;
      };
    };
  };
}
