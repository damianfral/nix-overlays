# This might be helfpul later:
# https://www.reddit.com/r/NixOS/comments/6hswg4/how_do_i_turn_an_overlay_into_a_proper_package_set/
self: super:

let
  inherit (super) lib stdenv pkgs;
  gitignoreNix = pkgs.fetchFromGitHub {
    owner = "hercules-ci";
    repo = "gitignore.nix";
    rev = "00b237fb1813c48e20ee2021deb6f3f03843e9e4";
    sha256 = "186pvp1y5fid8mm8c7ycjzwzhv7i6s3hh33rbi05ggrs7r3as3yy";
  };

  gitignoreSource = (import gitignoreNix { inherit lib; }).gitignoreSource;

  overlayOcamlPackages = version: {
    "ocamlPackages_${version}" =
        super.ocaml-ng."ocamlPackages_${version}".overrideScope'
          (pkgs.callPackage ./ocaml {});
  };
  ocamlVersions = ["4_06" "4_08" "4_09" "4_10" "4_11" ];
  oPs =
    lib.fold lib.mergeAttrs {}
    (builtins.map (version: overlayOcamlPackages version) ocamlVersions);

in
  {
    # Stripped down postgres without the `bin` part, to allow static linking
    # with musl
    libpq = super.postgresql.override { enableSystemd = false; };

    opaline = super.opaline.override {
      inherit (self) ocamlPackages;
    };

    ocamlPackages-bs = self.ocaml-ng.ocamlPackages_4_06.overrideScope' (oself: osuper: {
      ocaml = import ./bucklescript-experimental/ocaml.nix {
        stdenv = super.stdenv;
        src = "${self.bucklescript-experimental.src}/ocaml";
        version = "4.06.1+BS";
      };
    });

    ocamlPackages = oPs.ocamlPackages_4_10;
    ocamlPackages_latest = self.ocamlPackages;

    # 4.06, 4.09 and 4.10 treated specially out of convenience because:
    # - 4.09 is still used in some of my projects
    # - 4.10 is the latest stable version
    # - 4.06 is used by BuckleScript
    ocaml-ng = super.ocaml-ng // oPs;

    # BuckleScript
    bs-platform = pkgs.callPackage ./bs-platform {
      ocamlPackages = self.ocamlPackages-bs;
    };

    dune_2 =
      if lib.versionAtLeast self.ocamlPackages.ocaml.version "4.07"
      then self.ocamlPackages.dune_2
      else if lib.versionAtLeast self.ocamlPackages.ocaml.version "4.02"
      then self.ocaml-ng.ocamlPackages_4_10.dune_2
      else throw "dune_2 is not available for OCaml ${self.ocamlPackages.ocaml.version}";

    bucklescript-experimental = pkgs.callPackage ./bucklescript-experimental {
      ocamlPackages = self.ocamlPackages-bs;
      dune_2 = pkgs.ocamlPackages.dune_2;
    };

    pkgsCross.musl64.pkgsStatic =
      let mkOverlay = ocamlVersion: import ./static/overlays.nix {
        inherit lib ocamlVersion;
        pkgsNative = self.pkgs;
      };
      in
       super.pkgsCross.musl64.pkgsStatic.appendOverlays
       ((lib.concatMap mkOverlay ocamlVersions) ++ [
         (self: super: {
           ocaml = super.ocaml-ng.ocamlPackages_4_10.ocaml;
           ocamlPackages = super.ocaml-ng.ocamlPackages_4_10;
           ocamlPackages_latest = super.ocaml-ng.ocamlPackages_4_10;
           opaline = super.opaline.override {
             inherit (self) ocamlPackages;
           };
         })
       ]);

    # Other packages

    lib = super.lib // rec {
      inherit gitignoreSource;
      filterSource = { src, dirs ? [], files ? [] }: (super.lib.cleanSourceWith rec {
        inherit src;
        # Good examples: https://github.com/NixOS/nixpkgs/blob/master/lib/sources.nix
        filter = name: type:
          let
            path = toString name;
            baseName = baseNameOf path;
            relPath = lib.removePrefix (toString src + "/") path;
          in
            lib.any (dir: dir == relPath || (lib.hasPrefix "${dir}/" relPath)) dirs ||
            (type == "regular" && (lib.any (file: file == baseName) files));
      });
      filterGitSource = args: gitignoreSource (filterSource args);
    };

    cockroachdb = super.cockroachdb.overrideAttrs (o: {
      src = builtins.fetchurl {
        url = https://binaries.cockroachdb.com/cockroach-v20.1.4.src.tgz;
        sha256 = "1m82m776axyf7b5f1lzlv5y7zslyhikfxjgagqy7ci5zwn8j4i0n";
      };
    });
  }
