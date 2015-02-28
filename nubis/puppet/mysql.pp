$db_host = 'localhost'
$db_name = 'mediawiki'
$db_username = 'mediawiki'
$db_password = 'yXzeXEic7vgeCYFN'
$db_root_password = 'UboD3HBdi7qE9Edb'

class { '::mysql::server':
    root_password    => $::db_root_password,
    restart          => true,
    override_options => {
        'mysqld' => {
            'bind-address' => '0.0.0.0',
        }
    }
}

::mysql::db { $::db_name:
    user     => $::db_username,
    password => $::db_password,
    host     => $::db_host,
    # TODO, figure out how to pass this as a param. Unicode formating is breaking things.
    # The list looks like [u'SELECT', u'UPDATE', ...] and puppet doesn't like that.
    grant    => ['ALL']
}

include mysql::client
class { 'mysql::bindings':
    python_enable => true
}
