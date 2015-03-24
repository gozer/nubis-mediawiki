#!/bin/bash
#
# This script will get outputs from cloudformation and put them into consul
#
# You mustgive a settings file, typically this is the same parameters file you use with cloudformation
#
# TODO: gather all outputs and place them in consul. Right now I am just grabbing the database connection information
#+ however, it would be better if this script iterated over all outputs and placed them in consul.
#+ This would require refactering the cloudformation outputs to have part of the consul path in them
#+ For example, in the database user you would need "config/$DBUSER" instead of the current "$DBUSER".

get-settings () {
    if [ -f ${SETTINGS_FILE:-0} ]; then
        PROJECT_NAME=$(jq --monochrome-output --raw-output '.[] | if .ParameterKey == "ProjectName" then .ParameterValue else empty end | @text' $SETTINGS_FILE)
        NUBIS_ENVIRONMENT=$(jq --monochrome-output --raw-output '.[] | if .ParameterKey == "Environment" then .ParameterValue else empty end | @text' $SETTINGS_FILE)
        CONSUL_ENDPOINT=$(jq --monochrome-output --raw-output '.[] | if .ParameterKey == "ConsulEndpoint" then .ParameterValue else empty end | @text' $SETTINGS_FILE)
        CONSUL_ENDPOINT="ui.$CONSUL_ENDPOINT"
        STACK_NAME="nubis-$PROJECT_NAME"
    elif [ "$CONSUL_ENDPOINT" != "" ]; then
        echo "Using Environment for configuration"
    else
        echo "ERROR: You must specify a json settings file"
        exit 1
    fi
}

get-outputs () {
    AWS="aws cloudformation describe-stacks --stack-name $STACK_NAME --query Stacks[*].Outputs"
    if [ -f ${IO_FILE:-0} ]; then
        # Output to the file
        $AWS > $IO_FILE
    else
        $AWS
    fi
}

get-route53-nameservers () {
    ZONE_ID=$(aws cloudformation describe-stack-resources --stack-name $STACK_NAME --logical-resource-id  HostedZone --query StackResources[*].PhysicalResourceId --output text)
    aws route53 get-hosted-zone --id $ZONE_ID --query DelegationSet.NameServers
}

update-consul () {
    if [ ! -f ${IO_FILE:-0} ]; then
        echo "ERROR: Must pass a json file to update-consul"
        exit 1
    fi

    CONSUL="http://$CONSUL_ENDPOINT/v1/kv/$PROJECT_NAME/$NUBIS_ENVIRONMENT"
    COUNT=0
    NUM_OUTPUTS=$(jq --monochrome-output --raw-output '.[0] | length' $IO_FILE)
    while [ $COUNT -lt $NUM_OUTPUTS ]; do
        # Test to see if the description starts with 'Consul:'
        IS_CONSUL=$(jq --monochrome-output --raw-output ".[0][$COUNT] | .Description" $IO_FILE | cut -d " " -f 1)
        if [ $IS_CONSUL == "Consul:" ]; then
            # Grab the Consul path from the second element
            CONSUL_PATH=$(jq --monochrome-output --raw-output ".[0][$COUNT] | .Description" $IO_FILE | cut -d " " -f 2)
            # If the value is simply in root '/' we need to strip it or consul will not put it (ie // becomes /)
            if [ ${CONSUL_PATH:-0} == "/" ]; then
                unset CONSUL_PATH
            fi

            KEY=$(jq --monochrome-output --raw-output ".[0][$COUNT] | .OutputKey" $IO_FILE)
            VALUE=$(jq --monochrome-output --raw-output ".[0][$COUNT] | .OutputValue" $IO_FILE)
            echo "$VALUE $CONSUL_PATH/$KEY"
            curl -s -X PUT -d $VALUE ${CONSUL}/${CONSUL_PATH}${KEY}
        fi
        COUNT=$[$COUNT+1]
    done
}

get-and-update () {
    # If we do not get an I/O file then put on in temp
    if [ ! -f ${IO_FILE:-0} ]; then
        AUTOGEN_IO=1
        IO_FILE=$(mktemp /tmp/consul_io.json.XXXXXXXX)
    fi
    get-outputs
    update-consul
    if [ ${AUTOGEN_IO:-0} == 1 ]; then
        rm $IO_FILE
    fi
}

# Grab and setup called options
while [ "$1" != "" ]; do
    case $1 in
        -v | --verbose )
            # For this simple script this will basicaly set -x
            set -x
        ;;
        -s | --settings )
            # The name of a file, in json format, to get settings from
            SETTINGS_FILE=$2
            shift
            get-settings
        ;;
        -f | --file )
            # The name of a file to write the json outputs to.
            # This works regardless of other options to the file if data is being collected from AWS
            # If you are only updating Consul, this file is the location of the JSON data
            IO_FILE=$2
            shift
        ;;
         -h | -H | --help )
            echo -en "$0\n\n"
            echo -en "Usage: $0 [options] command\n\n"
            echo -en "Commands:\n"
            echo -en "  get-and-update              Run get-outputs followed by update-consul\n"
            echo -en "  get-outputs                 Get defined outputs\n"
            echo -en "  update-consul               Put values into Consul\n"
            echo -en "  get-route53-nameservers     Get the list of Route53 nameservers\n\n"
            echo -en "Options:\n"
            echo -en "  --help      -h              Print this help information and exit\n"
            echo -en "  --settings  -s              Specify a file containing settings\n"
            echo -en "                                This file should describe your consul credentials\n"
            echo -en "                                --settings nubis/cloudformation/parameters.json\n"
            echo -en "  --file      -f              Specify a file for reading and writing in json format\n"
            echo -en "                                If get-outputs will write to file (Optional) or print to sdtout\n"
            echo -en "                                If update-consul will read from file\n"
            echo -en "  --verbose   -v              Turn on verbosity\n"
            echo -en "                                Basically set -x\n\n"
            exit 0
        ;;
        get-outputs | get-out )
            # This simply grabs everything defined as an output and dumps it.
            # See --file if you wish to save to a file without a redirect
            get-outputs
        ;;
        update-consul )
            # Just pushes data to Consul, requires --file or stdin
            update-consul
        ;;
        get-route53-nameservers | get-ns)
            # Collect the Route53 ZoneId from AWS
            get-route53-nameservers
        ;;

        io | get-and-update )
            # Get the outputs from AWS and put them in Consul
            get-and-update
        ;;
    esac
    shift
done
