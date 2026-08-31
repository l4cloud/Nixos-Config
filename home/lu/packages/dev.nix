{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gh k9s neovim typescript supabase-cli cargo rustc nodejs lua luarocks go
    python3 uv pipx kubectl kubernetes-helm svelte-language-server terraform
    awscli2 azure-cli cloudlens google-cloud-sdk gcc opencode lazygit lazydocker
    docker unzip
  ];
}
