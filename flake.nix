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
      node = {
        path = ./templates/node;
      };
      python = {
        path = ./templates/python;
      };
      rust = {
        path = ./templates/rust;
      };
    };
  };
}
