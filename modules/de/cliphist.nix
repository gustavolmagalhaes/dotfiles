{ lib, config, ... }:
lib.my.mkModule { inherit config; } "de.cliphist" "Clipboard History" {
  hm.services.cliphist.enable = true;
}
