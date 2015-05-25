class fc_base::wordpress(
    $config = {}
){

    require 'fc_base::git'

    $tmp_dir = $config['install_dir']
    $target_dir = $config['target_dir']

    class { '::wordpress': 
        wp_owner => $config['wp_owner'],
        wp_group => $config['wp_group'],
        create_db => $config['create_db'],
        db_name => $config['db_name'],
        db_user => $config['db_user'],
        db_password => $config['db_password'],
        wp_table_prefix => $config['wp_table_prefix'],
        install_dir => $tmp_dir,
        version => $config['version'],
        wp_debug => $config['wp_debug']  
    }->

    exec { 'remove_wordpress_tar' :
        command => "rm -rf $tmp_dir/*.gz"
    }->

    exec { 'remove_wordpress_plugins' :
        command => "rm -rf $tmp_dir/wp-content/plugins/*"
    }->

    exec { 'copy_wordpress' :
        command => "cp -r $tmp_dir/* $target_dir/" 
    }->

    exec { 'remove_temp_wordpress' :
        command => "rm -rf $tmp_dir"
    }

    $config['plugins'].each |$plugin| {

        $name = $plugin['name']
        $url = $plugin['url']
        $folder = "$target_dir/wp-content/plugins"

        exec { "wget_plugin_$name" :
            command => "wget $url",
            cwd => $folder,
        }->
        exec { "unzip_plugin_$name" :
            command => "unzip *.zip",
            cwd => $folder,
        }->
        exec { "remove_plugin_${name}_zip" :
            command => "rm -rf *.zip",
            cwd => $folder,
        }
    }
}

