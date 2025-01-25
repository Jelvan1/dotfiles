def main [home_path: path, data_path: path] {
    install-packages $home_path $data_path
}

def install-packages [home_path: path, data_path: path]: nothing -> nothing {
    let patched_packages = install-patched-packages $home_path

    add-bucket extras main nerd-fonts

    let data = open $data_path
    let packages = $data.packages.common.all
    | append $data.packages.common.windows
    | append $data.packages.windows
    scoop install ...($packages | where $it not-in $patched_packages)

    for $app in [7z wezterm] {
        let context = scoop which $app
        | path expand -n
        | path basename -r "install-context.reg"
        reg import $context
    }
}

def install-patched-packages [home_path: path]: nothing -> list<string> {
    let bucket = $"($home_path)/.config/scoop/bucket"
    mkdir $bucket

    # don't set `$env.BAT_CONFIG_DIR`
    http get https://github.com/ScoopInstaller/Main/raw/master/bucket/bat.json
    | reject pre_install env_set persist
    | save -f $"($bucket)/bat.json"

    # don't set `$env.LUAROCKS_CONFIG` and use lua51
    http get https://github.com/ScoopInstaller/Main/raw/master/bucket/luarocks.json
    | reject pre_install env_set persist
    | update depends lua51
    | save -f $"($bucket)/luarocks.json"

    add-bucket versions # for lua51

    let package_paths = ls -f $bucket | get name
    scoop install ...$package_paths

    $package_paths | path parse | get stem
}

def add-bucket [...new_buckets: string]: nothing -> nothing {
    let old_buckets = scoop bucket list | str trim | detect columns | skip
    for $bucket in ($new_buckets | where $it not-in $old_buckets.Name) {
        scoop bucket add $bucket
    }
}
