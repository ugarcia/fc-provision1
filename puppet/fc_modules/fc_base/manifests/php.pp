class fc_base::php(
    $config = {}
){
    
    include php

    class { [
        'php::fpm',
        'php::cli',
        'php::extension::curl',
        'php::extension::intl',
        'php::extension::mcrypt',
        'php::extension::mysql',
        'php::extension::redis',
    ]: }->

    class { 'php::extension::xdebug':
        settings => $config['xdebug']
    }


    $config['fpm']['pools'].each |$pool| {  
    
        $name = $pool['name']

        file { "/etc/php5/fpm/pool.d/${name}.conf" :
            ensure => file,
            owner => 'root',
            group => 'root',
            mode => '0644',
            content => template('fc_base/php_fpm_pool.erb')
        }->

        exec { "reload_php_for_$name" : 
            command => 'service php5-fpm restart',
            user => 'root'
        }
    }  
}