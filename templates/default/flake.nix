{
  description = "virtual environments";
  inputs.utils.url = "github:hercules-ci/flake-parts";

  outputs =
    inputs@{ utils, nixpkgs, ... }:
    utils.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      perSystem =
        { pkgs, system, ... }:
        {
          _module.args = {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
              overlays = [
                (final: prev: { hello = prev.cowsay; })
                # ...
              ];
            };
          };
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              hello
              #...
            ];
            env.FOO = "BAR";
          };
        };

    };
}