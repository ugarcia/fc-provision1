class fc_base::mysql(
    $config = {}
){

    $users = $config['users']
    $databases = $config['databases']
    $grants = $config['grants']

    $usersMap = $users.reduce({}) |$acc, $user| { 
        $userKey = $user['name']
        $userData = { password_hash => mysql_password($user['password']) }
        $tmp = merge($acc, { "$userKey" => $userData })
        $tmp
    }

    $dbsMap = $databases.reduce({}) |$acc, $db| { 
        $dbKey = $db['name']
        $dbData = $db.filter |$entry| { $entry[0] != 'name' }
        $tmp = merge($acc, { "$dbKey" => $dbData })
        $tmp
    }

    $grantsMap = $grants.reduce({}) |$acc, $grant| { 
        $user = $grant['user']
        $table = $grant['table']
        $grantKey = "$user/$table"
        $tmp = merge($acc, { "$grantKey" => $grant })
        $tmp
    }

    class { '::mysql::server':
        users => $usersMap,
        databases => $dbsMap,
        grants => $grantsMap,
    }

    include '::mysql::client'
}