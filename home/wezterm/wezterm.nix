{
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./raw-config.lua;
  };
}