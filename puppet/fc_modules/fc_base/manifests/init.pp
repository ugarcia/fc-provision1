# == Class: fc_base
#
# Full description of class fc_base here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { fc_base:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Unai Garcia <unai@frontcoder.com>
#
# === Copyright
#
# Copyright 2015.
#
class fc_base {
    class { 'fc_nginx': }
}

class fc_base::setup(
    $disable_apache = true
) {
    require fc_base

    class { 'locales':
        locales        => ['en_US.UTF-8 UTF-8'],
        default_locale => 'en_US.UTF-8'
    }

    ensure_packages(['build-essential', 'vim', 'curl'])

    file { "/etc/profile.d/default_editor.sh":
        ensure  => file,
        content => 'export EDITOR=vim; export VISUAL=vim',
        mode    => '0755'
    }

    require fc_base::facts

    if ($disable_apache == true) and ($::is_apache_installed == 'true') {
        service { 'disable apache2':
            name   => 'apache2',
            ensure => stopped
        }->
        package {
            'apache2': ensure => purged;
            'apache2-bin': ensure => purged;
            'apache2-data': ensure => purged;
            'apache2.2-common': ensure => purged;
        }
    }
}
