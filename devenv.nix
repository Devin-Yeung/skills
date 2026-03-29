{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/packages/
  packages = with pkgs; [ oxfmt ];

  # https://devenv.sh/languages/
  languages.nix.enable = true;

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = {
    nixfmt.enable = true;
    # format markdown files via oxfmt
    markdownfmt = {
      enable = true;
      name = "format markdown files";
      entry = "${lib.getExe pkgs.oxfmt}";
      files = "\\.md$";
      excludes = [ ".devenv" ];
      language = "system";
      pass_filenames = false;
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
