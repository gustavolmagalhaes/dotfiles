# Import custom packages from ../packages directory
# Mirror of Diogo Correia's pattern:
#   pkgs.my.<package-name>
let
  packagesDir = ../packages;
in
{ lib, ... }:
_final: prev:
let
  scope = lib.makeScope prev.newScope (_self: { inherit lib; });
in
{
  my = lib.packagesFromDirectoryRecursive {
    inherit (scope) newScope callPackage;
    directory = packagesDir;
  };
}
