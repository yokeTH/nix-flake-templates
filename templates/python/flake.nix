{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            python
            pkgs.uv
            pkgs.pyright
            pkgs.ruff
          ];

          postShellHook = ''
            set -euo pipefail

            VENV_DIR=".venv"
            PYBIN="${python}/bin/python"

            if [[ ! -f pyproject.toml ]]; then
              echo "[uv] No pyproject.toml found — initializing project with uv"
              uv init --python "$PYBIN"
              # Optionally pin tools as dev deps on first init:
              # uv add --dev pyright ruff
            fi

            # Create/ensure project-local venv using the Nix Python
            if [[ ! -d "$VENV_DIR" ]]; then
              echo "[uv] creating $VENV_DIR with $("$PYBIN" -V)"
              uv venv --python "$PYBIN" "$VENV_DIR"
            fi

            # Prefer the project venv binaries
            export VIRTUAL_ENV="$PWD/$VENV_DIR"
            export PATH="$VIRTUAL_ENV/bin:$PATH"

            # Sync deps (use --frozen if you want to require an existing lock)
            if [[ -f uv.lock ]]; then
              uv sync --frozen || uv sync
            else
              uv sync
            fi

            echo "[uv] ready → $(python -V) | $(uv --version | head -n1)"
          '';
        };
      }
    );
}
