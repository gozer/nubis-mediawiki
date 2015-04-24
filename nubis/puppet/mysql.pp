include mysql::client
class { 'mysql::bindings':
    python_enable => true
}
