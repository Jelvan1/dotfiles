use std assert

def main [home_path: path, data_path: path] {
    let data = open $data_path
    let packages = $data.packages.common.all
    | append $data.packages.common.windows
    | append $data.packages.windows
    install-apps $packages $home_path

    rustup default stable
    rustup component add rust-analyzer

    install-regs $home_path
}

def install-apps [new_apps: list<string>, home_path: path]: nothing -> nothing {
    let old = scoop export | from json

    let new_buckets = [extras jelvan1 main nerd-fonts nonportable versions]
    let old_buckets = $old | get buckets.Name
    for $bucket in ($new_buckets | where $it not-in $old_buckets) {
        if $bucket == jelvan1 {
            scoop bucket add jelvan1 https://github.com/Jelvan1/scoop-bucket
        } else {
            scoop bucket add $bucket
        }
    }

    let patches = patches $home_path
    assert ($patches | columns | all { $in in $new_apps })
    let old_apps = $old | get apps | select Name Source
    let old_apps_patched = $old_apps | group-by { $in.Name in $patches }
    let uninstall_apps = [
        ...($old_apps_patched.false | where Source not-in $new_buckets)
        ...($old_apps_patched.true | where Source != ($patches | get $it.Name))
    ]
    if ($uninstall_apps | is-not-empty) {
        print "The following apps will be uninstalled:"
        print $uninstall_apps
        scoop uninstall -p ...$uninstall_apps.Name
    }

    let install_apps = (
        $new_apps
        | where $it not-in $old_apps.Name or $it in $uninstall_apps.Name
        | each {|app| $patches | get -o $app | default $app }
    )
    if ($install_apps | is-not-empty) {
        print "The following apps will be installed:"
        print $install_apps
        scoop install ...$install_apps
    }
}

def install-regs [home_path: path]: nothing -> nothing {
    (reg-add
        "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System"
        Wallpaper
        REG_SZ
        $"($home_path)/.local/share/wallpapers/Sunset-room.png")
    (reg-add
        "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System"
        WallpaperStyle
        REG_SZ
        4)

    (reg-add
        "HKLM\\SYSTEM\\CurrentControlSet\\Control\\FileSystem"
        LongPathsEnabled
        REG_DWORD
        0x1)
    (reg-add
        "HKLM\\SYSTEM\\CurrentControlSet\\Control\\Keyboard Layout"
        "Scancode Map"
        REG_BINARY
        (0x[00 00 00 00 00 00 00 00
            02 00 00 00 01 00 3A 00 # map Caps Lock to Escape
            00 00 00 00] | encode hex))
}

def patches [home_path: path]: nothing -> record {
    let bucket = $"($home_path)/.config/scoop/bucket"
    mkdir $bucket
    def patch [app: string, repo: string, patch: closure]: nothing -> path {
        let path = $"($bucket)/($app).json" | path expand
        http get $"https://github.com/ScoopInstaller/($repo)/raw/master/bucket/($app).json"
        | do $patch
        | save -f $path
        $path
    }
    {
        7zip: (
            patch 7zip Main {
                reject notes | patch-context-menu
            }
        )
        bat: (
            patch bat Main {
                # don't set `$env.BAT_CONFIG_DIR`
                reject env_set persist pre_install
            }
        )
        discord: (
            patch discord Extras {
                # don't use portable config dir
                reject persist
                | insert post_install [
                    r#'$cfg_dir = "$env:USERPROFILE/.config/discord"'#,
                    r#'New-Item -ItemType Directory -Path "$cfg_dir" -Force | Out-Null'#,
                    r#'New-Item -ItemType Junction -Path "$dir/data" -Target "$cfg_dir" | Out-Null'#
                ]
            }
        )
        glazewm-np: (
            patch glazewm-np Nonportable {
                # don't launch separate powershell process to keep control and
                # simplify as the current script has quite some problems during
                # installation and cleanup
                to json
                | jq r#'
                    .architecture[] |= (
                        .url += "#/setup.msi_"  | del(.installer))
                    | .autoupdate.architecture[]
                        .url += "#/setup.msi_"
                    | .installer.script = [
                        "if (!(is_admin)) { error \"$app requires admin rights to $cmd\"; break }",
                        "Start-Process msiexec -ArgumentList @('/i', \"$dir\\setup.msi_\", '/qn', '/norestart') -Wait -Verb RunAs"]
                    | .uninstaller.script = [
                        "if (!(is_admin)) { error \"$app requires admin rights to $cmd\"; break }",
                        "Start-Process msiexec -ArgumentList @('/x', \"$dir\\setup.msi_\", '/qn', '/norestart') -Wait -Verb RunAs"]
                    | del(.shortcuts)'#
                | from json
            }
        )
        keepassxc: (
            patch keepassxc Extras {
                # remove portable file => don't use portable config dir
                reject persist
                | update post_install r#'Remove-Item -Force "$dir/.portable"'#
            }
        )
        luarocks: (
            patch luarocks Main {
                # don't set `$env.LUAROCKS_CONFIG` and use lua51
                reject env_set persist pre_install | update depends lua51
            }
        )
        mpv: (
            patch mpv Extras {
                # remove portable folder => don't use config in scoop dir
                # https://mpv.io/manual/master/#files-on-windows
                reject persist
            }
        )
        wezterm: (
            patch wezterm Extras {
                reject notes | patch-context-menu
            }
        )
        zen-browser: (
            patch zen-browser Extras {
                reject notes persist post_install
            }
        )
    }
}

def patch-context-menu []: record -> record {
    upsert post_install {
        append r#'reg import "$dir\install-context.reg"'#
    }
    | upsert pre_uninstall {
        r#'reg import "$dir\uninstall-context.reg"'#
    }
}

def reg-add [key: string, value: string, type: string, data: string] {
    let result = reg query $key /v $value /t $type | complete | str trim
    if $result.exit_code == 0 {
        assert ($result.stderr | is-empty)
        assert ($result.stdout | str contains "1 match")
        let old_data = $result.stdout | lines | get 1 | split row -r \s+ | last
        if $data == $old_data {
            return
        }
    }
    reg add $key /v $value /t $type /d $data /f
}
