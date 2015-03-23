# Setup a local varnish instance for caching

class {'varnish':
  varnish_listen_port	=> 80,
  storage_type          => 'file',
  varnish_storage_size	=> '90%',
  varnish_storage_file  => '/mnt/varnish_storage.bin',
}

class {'varnish::ncsa': }

class { 'varnish::vcl': 
  backends => {}, # without this line you will not be able to redefine backend 'default'
}

varnish::probe {  'mediawiki_version': 
  url => '/Special%3AVersion'
}

varnish::backend { 'default': 
  host  => '127.0.0.1',
  port  => '8080',
  probe => 'mediawiki_version',
}
