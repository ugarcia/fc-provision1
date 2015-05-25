class fc_base::apt {

    ensure_packages([
        'build-essential',
        'vim',
        'curl',
        'unzip'
    ])

    file { "/etc/profile.d/default_editor.sh":
        ensure  => file,
        content => 'export EDITOR=vim; export VISUAL=vim',
        mode    => '0755'
    }
}