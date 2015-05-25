class fc_base::apache(
    $config = {}
) {

    class { 'fc_base::facts': }

    if ($config['disabled'] == true) and ($::is_apache_installed == true) {
        service { 'apache2':
            ensure => stopped
        }->
        package {
            'apache2': ensure => purged;
            'apache2-bin': ensure => purged;
            'apache2-data': ensure => purged;
            'apache2.2-common': ensure => purged
        }
    }
}