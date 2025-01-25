def main [home_path: path, data_path: path] {
    let data = open $data_path
    let packages = $data.packages.common.all
    | append $data.packages.common.windows
    | append $data.packages.windows
    install-apps $packages $home_path
}

def install-apps [new_apps: list<string>, home_path: path]: nothing -> nothing {
    use std assert

    let old = scoop export | from json

    let new_buckets = [extras main nerd-fonts versions]
    let old_buckets = $old | get buckets.Name
    for $bucket in ($new_buckets | where $it not-in $old_buckets) {
        scoop bucket add $bucket
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
        | each {|app| $patches | get -i $app | default $app }
    )
    if ($install_apps | is-not-empty) {
        print "The following apps will be installed:"
        print $install_apps
        scoop install ...$install_apps
    }

    let apps_with_context = [7zip wezterm]
    assert ($apps_with_context | all { $in in $new_apps })
    for $app in ($apps_with_context | where $it in $install_apps) {
        print $"Add ($app) as a context menu option:"
        reg import $"(scoop prefix $app)/install-context.reg"
    }
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
        bat: (
            patch bat Main {
                # don't set `$env.BAT_CONFIG_DIR`
                reject pre_install env_set persist
            }
        )
        luarocks: (
            patch luarocks Main {
                # don't set `$env.LUAROCKS_CONFIG` and use lua51
                reject pre_install env_set persist | update depends lua51
            }
        )
    }
}
