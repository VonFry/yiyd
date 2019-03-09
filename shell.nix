{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, bytestring, containers, hspec
      , optparse-applicative, random, stdenv, yaml
      }:
      mkDerivation {
        pname = "yiyd";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = false;
        isExecutable = true;
        enableSeparateDataOutput = true;
        executableHaskellDepends = [
          base bytestring containers optparse-applicative random yaml
        ];
        testHaskellDepends = [
          base bytestring containers hspec optparse-applicative random yaml
        ];
        homepage = "https://gitlab.com/Vonfry/yiyd";
        license = stdenv.lib.licenses.gpl3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
