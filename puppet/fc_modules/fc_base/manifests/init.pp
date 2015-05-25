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
#    class { 'fc_base::nginx': },
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
class fc_base (
    $config = {}
) {

    Exec { 
        path => "/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin",
        user  => $config['user'],
        group  => $config['group']       
    }

    file {$config['folders']:
        ensure => directory,
        owner => $config['user'],
        group => $config['group'],
        mode => 0775
    }->
    exec { 'apt-get_update':
      command => 'apt-get update',
      user => 'root'
    }->
    class { [
        'fc_base::apache',
        'fc_base::apt',
        'fc_base::git',
    ]: } ->     
    class { [
        'fc_base::mysql',
        'fc_base::php',
    ]: } ->   
    class { [
        'fc_base::nginx',
    ]: } ->       
    class { [
        'fc_base::wordpress',
    ]: } ->  
    class { [
        'fc_base::nodejs',
        'fc_base::bower',
        'fc_base::grunt',
    ]: }      
}
