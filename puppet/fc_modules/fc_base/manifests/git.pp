class fc_base::git(
    $config = {}
) {

    $aRepositories = $config['repositories']

    include git

    git::config { 
        'user.name': value => $config['user'];
        'user.email': value => $config['email']
    }

    $aRepositories.each |$repo| {

        $folder = $repo['folder']
        $url = $repo['url']
        $name = $repo['name']

        exec { "clear_$name" :
            command => "rm -rf $folder/$name" 
        }->   

        exec { "clone_$name" :
            command => "git clone $url $name",
            cwd    => "$folder"  
        }                     
    }


}