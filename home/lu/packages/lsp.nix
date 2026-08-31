{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gopls python3Packages.python-lsp-server terraform-ls tflint
    jdt-language-server lua-language-server typescript-language-server
    vscode-langservers-extracted emmet-language-server bash-language-server
    yaml-language-server stylua
  ];
}
