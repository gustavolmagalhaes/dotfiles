{ lib, config, inputs, pkgs, ... }:let
  ir_camera_path = "/dev/video2";
in lib.my.mkModule { inherit config; } "security.gaze" "gaze security" {

  imports = [
    inputs.gaze.nixosModules.default
  ];

  hm.home.packages = with pkgs; [
    v4l-utils
  ];

  services.gaze = {
    enable = true;
    gui.enable = true;
    mutableConfig = false;
    settings = {
      cameras = {
        rgb = "primary";
        ir = ir_camera_path;
        ir_frame_width = 400;
        ir_frame_height = 360;
        emitter_enabled = true;
      };
      security = {
        hybrid_policy = "and";
      };
    };
  };

  security.pam.services.swaylock.gaze = {
    enable = true;
    simultaneous = true;
  };
}
