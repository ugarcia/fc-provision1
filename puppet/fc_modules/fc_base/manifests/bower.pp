class fc_base::bower(
    $config = {}
){

    require 'fc_base::git'
    require 'fc_base::nodejs'

    $user = $fc_base::config['user']

    $aFolders = $config['folders']

    $aFolders.each |$folder| {

        exec { "install_bower_packages_$folder" :
            command => "bower install",
            cwd => $folder,
            environment => [ "HOME=/home/$user" ]        
        }                
    }
}