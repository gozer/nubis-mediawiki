# Define how apache should be installed and configured. This uses the
# puppetlabs-apache puppet module [0].
#
# [0] https://github.com/puppetlabs/puppetlabs-apache
#

$vhost_name = 'mediawiki.nubis.allizom.org'
$install_root = '/var/www/mediawiki'

class {
    'apache':
        default_mods        => true,
        default_vhost       => false,
        default_confd_files => false,
        mpm_module          => 'prefork';
    'apache::mod::php':;
    'apache::mod::remoteip':
        proxy_ips => [ '127.0.0.1', '10.0.0.0/8' ];
}

apache::vhost { $::vhost_name:
    port          => '8080',
    default_vhost => true,
    docroot       => $::install_root,
    docroot_owner => 'ubuntu',
    docroot_group => 'ubuntu',
    block             => ['scm'],
    access_log_format => '%a %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"',
    rewrites      => [
    {
      comment      => 'Dont rewrite requests for files in MediaWiki subdirectories',
      rewrite_cond => ['%{REQUEST_URI} !^/(assets|extensions|images|skins|resources)/',
        '%{REQUEST_URI} !^/(redirect|index|opensearch_desc|api|load|thumb).php',
        '%{REQUEST_URI} !^/error/(40(1|3|4)|500).html',
        '%{REQUEST_URI} !=/favicon.ico',
        '%{REQUEST_URI} !^/robots.txt'
        ],
      rewrite_rule => ['^/(.*$) %{DOCUMENT_ROOT}/index.php [L]'
                      ],
    },
  ],
}
