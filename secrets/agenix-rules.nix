let
  ace = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJV2u1tNpNISA0cxOZkKm4HS/FHlNmNL5TydjyIzIcp gus@ace";

  users = [ace];


  # usersAndSystems = users ++ systems;
in {
  "baikal_password.age".publicKeys = users;
  "ist-secrets-env.age".publicKeys = users;
}
