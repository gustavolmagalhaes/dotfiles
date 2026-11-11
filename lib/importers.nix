{ lib, ... }:
let
  rakeLeaves = rakeLeavesWithSuffix ".nix" { defaultName = "default"; };

  rakeLeavesWithSuffix =
    suffix:
    args@{
      defaultName ? null,
    }:
    dirPath:
    let
      seive =
        file: type:
        # Only rake files ending in suffix or directories
        (type == "regular" && lib.hasSuffix suffix file) || (type == "directory");

      collect = file: type: {
        name = lib.removeSuffix suffix file;
        value =
          let
            path = dirPath + "/${file}";
          in
          if
            (type == "regular")
            || (
              defaultName != null
              && type == "directory"
              && builtins.pathExists (path + "/${defaultName}${suffix}")
            )
          then
            path
          # recurse on directories that don't contain a default file
          else
            rakeLeavesWithSuffix suffix args path;
      };

      files = lib.filterAttrs seive (builtins.readDir dirPath);
    in
    lib.filterAttrs (_n: v: v != { }) (lib.mapAttrs' collect files);
in
{
  inherit rakeLeaves rakeLeavesWithSuffix;
}
