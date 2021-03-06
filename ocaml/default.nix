{ callPackage, libpq, opaline, lib, stdenv, pkgconfig, openssl }:

oself: osuper:

with oself;

let
  alcotestPackages = callPackage ./alcotest {
    ocamlPackages = oself;
  };

  archiPackages = callPackage ./archi {
    ocamlPackages = oself;
    ocamlVersion = osuper.ocaml.version;
  };

  caqti-packages = callPackage ./caqti {
    ocamlPackages = oself;
  };

  conduit-packages = callPackage ./conduit {
    ocamlPackages = oself;
  };

  dataloader-packages = callPackage ./dataloader {
    ocamlPackages = oself;
  };

  faradayPackages = callPackage ./faraday {
    ocamlPackages = oself;
  };

  graphqlPackages = callPackage ./graphql {
    ocamlPackages = oself;
  };

  glutenPackages = callPackage ./gluten {
    ocamlPackages = oself;
    ocamlVersion = osuper.ocaml.version;
  };

  h2Packages = callPackage ./h2 {
    ocamlPackages = oself;
    ocamlVersion = osuper.ocaml.version;
  };

  httpafPackages = callPackage ./httpaf {
    ocamlPackages = oself;
    ocamlVersion = osuper.ocaml.version;
  };

  ipaddrPackages = callPackage ./ipaddr {
    ocamlPackages = oself;
  };

  janestreetPackages = callPackage ./janestreet {
    ocamlPackages = oself;
  };

  junitPackages = callPackage ./junit {
    ocamlPackages = oself;
  };

  kafka-packages = callPackage ./kafka {
    ocamlPackages = oself;
  };

  lambda-runtime-packages = callPackage ./lambda-runtime {
    ocamlPackages = oself;
  };

  menhirPackages = if !stdenv.lib.versionAtLeast osuper.ocaml.version "4.07"
    then {}
    else callPackage ./menhir {
      ocamlPackages = oself;
    };

  opamPackages = callPackage ./opam {
    ocamlPackages = oself;
  };

  piafPackages = callPackage ./piaf { ocamlPackages = oself; };

  reasonPackages = callPackage ./reason {
    ocamlPackages = oself;
  };

  websocketafPackages = callPackage ./websocketaf {
    ocamlPackages = oself;
    ocamlVersion = osuper.ocaml.version;
  };

in
  alcotestPackages //
  archiPackages //
  caqti-packages //
  conduit-packages //
  dataloader-packages //
  faradayPackages //
  graphqlPackages //
  glutenPackages //
  h2Packages //
  httpafPackages //
  ipaddrPackages //
  janestreetPackages //
  junitPackages //
  kafka-packages //
  lambda-runtime-packages //
  menhirPackages //
  opamPackages //
  piafPackages //
  reasonPackages //
  websocketafPackages // {
    async_ssl = buildDunePackage rec {
      version = "0.13.0";
      pname = "async_ssl";
      useDune2 = true;
      src = builtins.fetchurl {
        url = "https://github.com/janestreet/${pname}/archive/v${version}.tar.gz";
        sha256 = "0lgjkjhm1x0s539syzxixdi941ahbldhvp6jn7ycz07iqwhg9b9n";
      };
      propagatedBuildInputs = [
        async
        base
        core
        ppx_jane
        stdio
        openssl.dev
        ctypes
        dune-configurator
      ];
    };

    base64 = callPackage ./base64 {
      ocamlPackages = oself;
    };

    calendar = callPackage ./calendar { ocamlPackages = oself; };

    camlzip = osuper.camlzip.overrideAttrs (o: {
      buildFlags = if stdenv.hostPlatform != stdenv.buildPlatform then
        # TODO: maybe use a patch instead
        "all zip.cmxa"
        else
          o.buildFlags;

      src = builtins.fetchurl {
        url = https://github.com/xavierleroy/camlzip/archive/rel110.tar.gz;
        sha256 = "1ckxf9d19x63crkcn54agn5p77a9s84254s84ig53plh6rriqijz";
      };
    });

    coin = callPackage ./coin { ocamlPackages = oself; };

    cppo = buildDunePackage rec {
      pname = "cppo";
      version = "1.6.6";
      src = builtins.fetchurl {
        url = https://github.com/ocaml-community/cppo/releases/download/v1.6.6/cppo-v1.6.6.tbz;
        sha256 = "185q0x54id7pfc6rkbjscav8sjkrg78fz65rgfw7b4bqlyb2j9z7";
      };
    };

    ctypes = osuper.ctypes.overrideAttrs (o: {
      src = builtins.fetchurl {
        url = https://github.com/ocamllabs/ocaml-ctypes/archive/0.17.1.tar.gz;
        sha256 = "1sd74bcsln51bnz11c82v6h6fv23dczfyfqqvv9rxa9wp4p3qrs1";
      };
    });

    cudf = callPackage ./cudf { ocamlPackages = oself; };

    dose3 = callPackage ./dose3 { ocamlPackages = oself; };

    # Make `dune` effectively be Dune v2.  This works because Dune 2 is
    # backwards compatible.
    dune = if lib.versionOlder "4.07" ocaml.version
      then oself.dune_2
      else osuper.dune;

    dune_2 = osuper.dune_2.overrideAttrs (o: {
      src = builtins.fetchurl {
        url = https://github.com/ocaml/dune/releases/download/2.7.0/dune-2.7.0.tbz;
        sha256 = "058wiyncczbmlfxj3cnwn5n68wkmbaf4mgjm2bkp2hffpn2wl5xl";
      };
    });

    ezgzip = buildDunePackage rec {
      pname = "ezgzip";
      version = "0.2.3";
      src = builtins.fetchurl {
        url = "https://github.com/hcarty/${pname}/archive/v${version}.tar.gz";
        sha256 = "0zjss0hljpy3mxpi1ccdvicb4j0qg5dl6549i23smy1x07pr0nmr";
      };
      propagatedBuildInputs = [rresult astring ocplib-endian camlzip result ];
    };

    graphql_ppx = callPackage ./graphql_ppx {
      ocamlPackages = oself;
    };

    janeStreet = janestreetPackages;

    jose = callPackage ./jose { ocamlPackages = oself; };

    js_of_ocaml-compiler = osuper.js_of_ocaml-compiler.overrideAttrs (o: {
      propagatedBuildInputs = o.propagatedBuildInputs ++ [ menhir ];
      src = builtins.fetchurl {
        url = https://github.com/ocsigen/js_of_ocaml/releases/download/3.7.0/js_of_ocaml-3.7.0.tbz;
        sha256 = "0rw6cfkl3zlyav8q2w7grxxqjmg35mz5rgvmkiqb58nl4gmgzx6w";
      };
    });

    ke = osuper.ke.overrideAttrs (o: {
      src = builtins.fetchurl {
        url = https://github.com/mirage/ke/archive/0b3d570f56c558766e8d53600e59ce65f3218556.tar.gz;
        sha256 = "01i20hxjbvzh2i82g8lk44hvnij5gjdlnapcm55balknpflyxv9f";
      };
    });

    lwt = osuper.lwt.overrideAttrs (o: {
      buildInputs = o.buildInputs ++ [ dune-configurator ocaml-syntax-shims ];
    });

    magic-mime = callPackage ./magic-mime {
      ocamlPackages = oself;
    };

    merlin = osuper.merlin.overrideAttrs (o: {
      src = builtins.fetchurl {
        url = https://github.com/ocaml/merlin/archive/v3.3.9.tar.gz;
        sha256 = "1g3w1i0x7c728a6nfmj7kj5z0p3p8n1rv80psnz6j801bdv0wi8r";
      };
    });

    mirage-crypto = osuper.mirage-crypto.overrideAttrs (o: {
      src = builtins.fetchurl {
        url = https://github.com/mirage/mirage-crypto/releases/download/v0.8.5/mirage-crypto-v0.8.5.tbz;
        sha256 = "0l6q0z5ghhy0djfscb2i2xg4dpmxs4xkwh16kc473cmb4hsxsmyk";
      };
    });

    mirage-kv = buildDunePackage {
      pname = "mirage-kv";
      version = "3.0.1";
      src = builtins.fetchurl {
        url = https://github.com/mirage/mirage-kv/releases/download/v3.0.1/mirage-kv-v3.0.1.tbz;
        sha256 = "1n736sjvdd8rkbc2b5jm9sn0w6hvhjycma5328r0l03v24vk5cki";
      };
      propagatedBuildInputs = [
        lwt
        mirage-device
        fmt
      ];
    };

    mtime = osuper.mtime.override { jsooSupport = false; };

    multipart_form = callPackage ./multipart_form { ocamlPackages = oself; };

    ocaml-migrate-parsetree = osuper.ocaml-migrate-parsetree.overrideAttrs (o: {
      version = "1.7.3";
      src = builtins.fetchurl {
        url = https://github.com/ocaml-ppx/ocaml-migrate-parsetree/archive/v1.7.3.tar.gz;
        sha256 = "1x7i6zkfglvj935q45wgd7pk16g2dhqdlz781whrzslm5mj3f4i2";
      };
    });

    ocaml = osuper.ocaml.override { flambdaSupport = true; };

    uunf = osuper.uunf.overrideAttrs (o: {
      # https://github.com/ocaml/ocaml/issues/9839
      configurePhase = lib.optionalString (lib.versionOlder "4.11" osuper.ocaml.version)
      ''
        ulimit -s 9216
      '';
    });

    ocamlgraph = osuper.ocamlgraph.override { lablgtk = null; };

    ocplib-endian = callPackage ./ocplib-endian { ocamlPackages = oself; };

    pecu = callPackage ./pecu { ocamlPackages = oself; };

    pg_query = callPackage ./pg_query { ocamlPackages = oself; };

    ppx_rapper = callPackage ./ppx_rapper { ocamlPackages = oself; };

    postgresql = buildDunePackage rec {
      pname = "postgresql";
      version = "4.6.3";
      src = builtins.fetchurl {
        url = "https://github.com/mmottl/postgresql-ocaml/releases/download/${version}/${pname}-${version}.tbz";
        sha256 = "0ya1jl75w8dand9pj1a7sfb0nwi8ll15g5alpvfnn11vn60am01w";
      };
      nativeBuildInputs = [ dune-configurator ];
      propagatedBuildInputs = [ libpq ];
    };

    ppx_cstruct = osuper.ppx_cstruct.overrideAttrs (o: {
      propagatedBuildInputs = o.propagatedBuildInputs ++ [ ppx_tools_versioned ];
    });

    ppxfind = callPackage ./ppxfind { ocamlPackages = oself; };

    # ppxlib = osuper.ppxlib.overrideAttrs (o: {
      # src = builtins.fetchurl {
        # url = https://github.com/ocaml-ppx/ppxlib/releases/download/0.16.0/ppxlib-0.16.0.tbz;
        # sha256 = "1maydiydnx0357v4qw7npyph0fq26kqcl3yk5kgif3xq0ribidx2";
      # };
      # propagatedBuildInputs = [
        # ocaml-compiler-libs
        # ocaml-migrate-parsetree
        # ppx_derivers
        # sexplib0
        # stdlib-shims
      # ];
    # });

    ppx_deriving = osuper.ppx_deriving.overrideAttrs (o: {
      src = builtins.fetchurl {
        url = https://github.com/ocaml-ppx/ppx_deriving/archive/e6cbddb82ea39ea56dbc541ed18c22f6bde596b7.tar.gz;
        sha256 = "0cj8cpn3vc8bsd0vpl5s6xhk318vbvs7dkfy8rbaavwqq3mdkr8f";
      };
      buildInputs = o.buildInputs ++ [ cppo ];
      propagatedBuildInputs = [ ppxlib result ppx_derivers ];
    });

    ppx_deriving_yojson = osuper.ppx_deriving_yojson.overrideAttrs (o: {
      src = builtins.fetchurl {
        url = https://github.com/ocaml-ppx/ppx_deriving_yojson/archive/d06711479564486554aa0834fe900ac27d55ccc4.tar.gz;
        sha256 = "0gpzm4v2h0jxvnalacivwsq31kx9svbgg626d17076ll0mipywvd";
      };
      propagatedBuildInputs = [ ppxlib ppx_deriving yojson ];
    });

    ppx_blob = osuper.ppx_blob.overrideAttrs (o: {
      src = builtins.fetchurl {
        url = https://github.com/johnwhitington/ppx_blob/releases/download/0.7.0/ppx_blob-0.7.0.tbz;
        sha256 = "0r8wsdhjh6ricv85mr8f8a7fkcxzls6dxv6jymy8nykgjvvkb2mc";
      };
    });

    ptime =
      let
        filterJSOO = p:
          !(lib.hasAttr "pname" p && (p.pname == "js_of_ocaml"));
      in
      osuper.ptime.overrideAttrs (o: {
        src = builtins.fetchurl {
          url = https://github.com/dbuenzli/ptime/archive/e85b030c862715eb579b3b902c8eed3f9b985d72.tar.gz;
          sha256 = "0qr6wall0yv1i581anhly46jp34p7q4v011rnr84p9yfj4r6kphp";
        };

        buildInputs = lib.filter filterJSOO o.buildInputs;
        propagatedBuildInputs = lib.filter filterJSOO o.propagatedBuildInputs;
        propagatedNativeBuildInputs = lib.filter filterJSOO (o.propagatedNativeBuildInputs or []);

        buildPhase = "${topkg.run} build --with-js_of_ocaml false";
      });

    rosetta = callPackage ./rosetta { ocamlPackages = oself; };

    routes = callPackage ./routes { ocamlPackages = oself; };

    ssl = osuper.ssl.overrideAttrs (o: {
      version = "0.5.9-dev";
      src = builtins.fetchurl {
        url = https://github.com/savonet/ocaml-ssl/archive/fbffa9b.tar.gz;
        sha256 = "1zf6i4z5aq45in430pagp8cz2q65jdhsdpsgpcdysjm4jlfsswr1";
      };

      nativeBuildInputs = [ dune-configurator pkgconfig ];
      propagatedBuildInputs = [ openssl.dev ];
    });

    stdlib-shims = osuper.stdlib-shims.overrideAttrs (o: {
      src = builtins.fetchurl {
        url = https://github.com/ocaml/stdlib-shims/releases/download/0.2.0/stdlib-shims-0.2.0.tbz;
        sha256 = "0nb5flrczpqla1jy2pcsxm06w4jhc7lgbpik11amwhfzdriz0n9c";
      };
    });

    syndic = buildDunePackage rec {
      pname = "syndic";
      version = "1.6.1";
      src = builtins.fetchurl {
        url = "https://github.com/Cumulus/${pname}/releases/download/v${version}/syndic-v${version}.tbz";
        sha256 = "1i43yqg0i304vpiy3sf6kvjpapkdm6spkf83mj9ql1d4f7jg6c58";
      };
      propagatedBuildInputs = [ xmlm uri ptime ];
    };

    tls-mirage = buildDunePackage {
      pname = "tls-mirage";
      version = osuper.tls.version;
      src = osuper.tls.src;
      propagatedBuildInputs = [
        tls
        x509
        fmt
        lwt
        mirage-flow
        mirage-kv
        mirage-clock
        ptime
        mirage-crypto
        mirage-crypto-pk
      ];
    };

    topkg = osuper.topkg.overrideAttrs (o: {
      src = builtins.fetchurl {
        url = https://github.com/dbuenzli/topkg/archive/v1.0.2.tar.gz;
        sha256 = "0qfp25s16yx9zhij7dwrr3qspsmw5k5v9f55lq5ii9djn3acyqj2";
      };
    });

    uchar = osuper.uchar.overrideAttrs (o: {
      installPhase = "${opaline}/bin/opaline -libdir $OCAMLFIND_DESTDIR";
      nativeBuildInputs = [ocamlbuild ocaml findlib];
      buildInputs = [ocamlbuild ocaml findlib];
    });

    unstrctrd = callPackage ./unstrctrd { ocamlPackages = oself; };

    uri = osuper.uri.overrideAttrs (o: {
      src = builtins.fetchurl {
        url = https://github.com/anmonteiro/ocaml-uri/archive/8634a6923ac8a757d7ac7882aa80a3f8090732c6.tar.gz;
        sha256 = "10gsahap5m081swkl2frdsh4jj7lirrpm5g4alcv60ihc1vwbyyd";
      };
      doCheck = false;
      propagatedBuildInputs = o.propagatedBuildInputs ++ [ angstrom ];
    });

    uuuu = callPackage ./uuuu { ocamlPackages = oself; };

    vchan = buildDunePackage {
      pname = "vchan";
      version = "5.0.0";
      src = builtins.fetchurl {
        url = https://github.com/mirage/ocaml-vchan/releases/download/v5.0.0/vchan-v5.0.0.tbz;
        sha256 = "0bx55w0ydl4bdhm6z5v0qj2r59j4avzddhklbb1wx40qvg3adz63";
      };
      propagatedBuildInputs = [
        lwt
        cstruct
        ppx_sexp_conv
        ppx_cstruct
        io-page
        mirage-flow
        xenstore
        xenstore_transport
        sexplib
        cmdliner
      ];
    };

    xenstore = buildDunePackage {
      pname = "xenstore";
      version = "2.1.0";
      src = builtins.fetchurl {
        url = https://github.com/mirage/ocaml-xenstore/releases/download/2.1.1/xenstore-2.1.1.tbz;
        sha256 = "1xc49j3n3jap2n3w7v6a9q08a4bw5xxv3z4wsp24bhxd47m18f18";
      };
      propagatedBuildInputs = [
        cstruct
        ppx_cstruct
        lwt
      ];
    };

    xenstore_transport = buildDunePackage (rec {
      pname = "xenstore_transport";
      version = "1.1.0";
      src = builtins.fetchurl {
        url = "https://github.com/xapi-project/ocaml-xenstore-clients/archive/v${version}.tar.gz";
        sha256 = "1lggdxw1ai66irmnzn9rifz2ksbvngsfi2rc0xz4d8wph1y2yzlv";
      };
      propagatedBuildInputs = [
        lwt
        xenstore
      ];
    });

    yaml = osuper.yaml.overrideAttrs (o: rec {
      version = "2.1.0";
      src = builtins.fetchurl {
        url = "https://github.com/avsm/ocaml-yaml/archive/v${version}.tar.gz";
        sha256 = "1dnzlb8y568smzxwyx6iqpgih63nhgr997yqwpdy38d1014vwlqy";
      };
    });

    yojson = buildDunePackage {
      pname = "yojson";
      version = "1.7.0";
      src = builtins.fetchurl {
        url = https://github.com/ocaml-community/yojson/releases/download/1.7.0/yojson-1.7.0.tbz;
        sha256 = "1iich6323npvvs8r50lkr4pxxqm9mf6w67cnid7jg1j1g5gwcvv5";
      };

      propagatedNativeBuildInputs = [ cppo ];
      propagatedBuildInputs = [ easy-format biniou ];
    };

    yuscii = callPackage ./yuscii { ocamlPackages = oself; };

    zarith = osuper.zarith.overrideAttrs (o: {
      src = builtins.fetchurl {
        url = https://github.com/ocaml/zarith/archive/a9a309d0596d93b6c0c902951e1cae13d661bebd.tar.gz;
        sha256 = "067vr029idkljhndpk7c8gljmxbaszmav09y5k1j6xy67x5wb0sj";
      };
    });

    zed = callPackage ./zed {
      ocamlPackages = oself;
    };
  }
