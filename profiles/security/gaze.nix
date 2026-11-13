{inputs,...}:
{
  # imports = [
  #   inputs.gaze.nixosModules.default
  # ];


  services.gaze = {
    enable = true;
    gui.enable = true;
  };


  security.pam.services.swaylock.gaze = {
    enable = true;
    simultaneous = true;
  };
}
