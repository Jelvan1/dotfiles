# dotfiles

A collection of my personal dotfiles.

## Installation

1. Install basic packages:

   <details>
   <summary>Linux</summary>

   ```sh
   sudo pacman -S --needed chezmoi git nushell
   ```

   </details>

   <details>
   <summary>Windows</summary>

   Requirement: [Scoop](https://github.com/ScoopInstaller/Install?tab=readme-ov-file#installation)

   ```ps1
   scoop install chezmoi git nu
   git config --global core.autocrlf false
   ```

   </details>

1. Set up full environment:

   ```nu
   chezmoi init Jelvan1
   chezmoi apply
   ```

1. Profit.
