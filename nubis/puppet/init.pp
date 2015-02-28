# Main entry for puppet
#
# import is depricated and we should use another method for including these
#+ manifests
#

import 'apache.pp'
import 'mysql.pp'
import 'fluentd.pp'
import 'nubis_configuration.pp'
#include nubis_configuration
