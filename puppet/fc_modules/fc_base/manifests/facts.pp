class fc_base::facts() {
    file { '/etc/facter':
        ensure => directory
    }->
    file { '/etc/facter/facts.d':
        ensure => directory
    }->
    file { '/etc/facter/facts.d/fc_facts.sh':
        ensure  => file,
        content => template('fc_base/facts.erb'),
        mode    => '0755',
        owner   => 'root',
        group   => 'root'
    }
}