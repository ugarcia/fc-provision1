class fc_base::nodejs(
    $config = {}
){

    require 'fc_base::apt'
    require 'fc_base::git'

    $node_src = $config['source']
    $node_v = $config['version']
    $aGlobalPackages = $config['packages']['global']
    $aScopedPackages = $config['packages']['scoped']

    $globalPackagesString = $aGlobalPackages.join(" ")

    exec { 'install_nodejs' :
        command => "curl -sL ${node_src}/setup_${node_v} | sudo bash -",
        unless => [ "test -f /usr/bin/node" ]
    }->

    package { 'nodejs' :
        ensure => present
    }->

    exec { 'install_nodejs_global_packages' :
        command => "npm install -g ${globalPackagesString}",
        user => "root"       
    }

    $aScopedPackages.each |$folder| {

        exec { "install_nodejs_packages_$folder" :
            command => "npm install",
            cwd    => $folder
        }                
    }
}