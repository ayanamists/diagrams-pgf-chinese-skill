{
  description = "Haskell diagrams-pgf environment with XeLaTeX Chinese text support";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f (import nixpkgs {
            inherit system;
          })
        );
    in
    {
      devShells = forAllSystems (pkgs:
        let
          haskellEnv = pkgs.haskellPackages.ghcWithPackages (ps: with ps; [
            diagrams
            diagrams-contrib
            diagrams-lib
            diagrams-pgf
          ]);

          texEnv = pkgs.texlive.combine {
            inherit (pkgs.texlive) scheme-small;
            inherit (pkgs.texlivePackages)
              ctex
              dvisvgm
              latexmk
              pgf
              preview
              standalone
              xecjk
              xetex
              ;
          };
        in
        {
          default = pkgs.mkShell {
            packages = [
              haskellEnv
              pkgs.cabal-install
              pkgs.gnumake
              texEnv
            ];

            shellHook = ''
              echo "diagrams-pgf shell: build with make; Chinese text is handled by ctex + xelatex."
            '';
          };
        });
    };
}
