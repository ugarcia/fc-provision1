class fc_base::nginx (
    $config = {}
) {
    
    file { "/etc/hosts" :
        ensure => file,
        owner => 'root',
        group => 'root',
        content => template('fc_base/hosts.erb')
    }

    class { '::nginx': }

    $config['vhosts'].each |$vhost| {

        $domain = $vhost['domain']

        file { "${nginx::config::conf_dir}/sites-available/${domain}.conf" :
            ensure => file,
            owner => $nginx::config::global_owner,
            group => $nginx::config::global_group,
            mode => $nginx::config::global_mode,
            content => template('fc_base/nginx_vhost.erb')
        }->

        file { "${nginx::config::conf_dir}/sites-enabled/${domain}.conf" :
            ensure => link,
            target => "${nginx::config::conf_dir}/sites-available/${domain}.conf",
            owner => $nginx::config::global_owner,
            group => $nginx::config::global_group,
            mode => $nginx::config::global_mode,
        }->

        exec { "reload_nginx_for_$domain" : 
            command => 'service nginx restart',
            user => 'root'
        }
    }


}