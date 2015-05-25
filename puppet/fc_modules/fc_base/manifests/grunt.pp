class fc_base::grunt(
    $config = {}
){

    require 'fc_base::git'
    require 'fc_base::nodejs'
    require 'fc_base::bower'

    # $user = $fc_base::config['user']

    $aFolders = $config['folders']

    $aFolders.each |$folder| {

        exec { "grunt_task_$folder" :
            command => "grunt",
            cwd => $folder,
            # environment => [ "HOME=/home/$user" ]        
        }                
    }
}