# Define how apache should be installed and configured. This uses the
# puppetlabs-apache puppet module [0].
#
# [0] https://github.com/puppetlabs/puppetlabs-apache
#

$vhost_name = 'nubis-mediawiki.allizom.org'
$install_root = '/var/www/mediawiki'

class {
    'apache':
        default_mods        => true,
        default_confd_files => false,
        mpm_module          => 'prefork';
    'apache::mod::php':
}

apache::vhost { $::vhost_name:
    port          => '80',
    default_vhost => true,
    docroot       => $::install_root,
    docroot_owner => 'ubuntu',
    docroot_group => 'ubuntu',
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
