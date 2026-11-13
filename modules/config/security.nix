# Monitor configuration
{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.my.config.security = {
    ir_camera_path = mkOption {
      description = "Path to IR camera if you have it for gaze facial authentication";
      default = "";
      type = types.str;
    };
  };

  config = {
    # assertions = [
    #   {
    #     assertion =
    #       config.my.config.security != [ ]
    #       -> lib.length (lib.filter (m: m.primary) config.my.config.security) == 1;
    #     message = "`my.config.graphical.monitors` must have exactly one primary monitor.";
    #   }
    # ];
  };
}
