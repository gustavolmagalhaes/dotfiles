# Git version control
{ userFullName, ... }:
{
  hm.programs.git = {
    enable = true;
    settings.user = {
      name = userFullName;
      email = "g.lobomagalhaes@gmail.com";
    };
  };
}
