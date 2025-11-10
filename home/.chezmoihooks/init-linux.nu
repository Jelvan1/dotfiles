def main [home_path: path, data_path: path] {
    open /etc/pacman.conf
    | str replace -mr r#'^#Color$'# "Color"
    | str replace -mr r#'^#VerbosePkgLists$'# "VerbosePkgLists"
    | sudo nu --stdin -c "save -f /etc/pacman.conf"

    sudo pacman -S --needed base-devel
    if (which yay | is-empty) {
        git clone --depth 1 https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
        makepkg -D /tmp/yay-bin -is
        rm -fr /tmp/yay-bin
        yay --aur
    }

    let data = open $data_path
    let packages = $data.packages.common.all
    | append $data.packages.common.linux
    | append $data.packages.linux
    yay -S --needed ...$packages

    # https://wiki.archlinux.org/title/Rust#Arch_Linux_package
    rustup default stable

    if $env.SHELL != /bin/nu {
        chsh -s /bin/nu
    }

    if (open /proc/sys/kernel/osrelease | str contains -i microsoft) {
        # fix `Can't open display: :0` for ArchWSL - fails to create X server's X11 display socket
        # https://github.com/yuk7/ArchWSL/issues/342
        # https://github.com/microsoft/wslg/wiki/Diagnosing-%22cannot-open-display%22-type-issues-with-WSLg#x11-display-socket
        let socket = (ls -lD /tmp/.X11-unix | get 0)
        if $socket.type == symlink and $socket.target == /mnt/wslg/.X11-unix {
            return
        }

        # note: `wsl --shutdown` is required
        "L+ /tmp/.X11-unix - - - - /mnt/wslg/.X11-unix"
        | sudo nu --stdin -c "save -f /etc/tmpfiles.d/wslg.conf"
    }

    systemctl --user enable --now pueued
}
