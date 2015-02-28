include nubis_configuration

#class class::nubis_configuration {...}

nubis::configuration{ 'mediawiki':
        format => "php",
#        check  => "apachectl configtest",
        reload => "apachectl graceful",
}
