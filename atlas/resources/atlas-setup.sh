#!/bin/bash

function faketty { script -qfc "$(printf "%q " "$@")" /dev/null ; }

if [[ -z "$START_TIMEOUT" ]]; then
    START_TIMEOUT=900
fi

start_timeout_exceeded=false
count=0
step=10
while netstat -lnt | awk '$4 ~ /:21000$/ {exit 1}'; do
    echo "waiting for atlas to be ready"
    sleep $step;
    count=$(expr $count + $step)
    if [ $count -gt $START_TIMEOUT ]; then
        start_timeout_exceeded=true
        break
    fi
done

# if [ "$start_timeout_exceeded" = "false" ]; then
#     # Setup atlas types
#     printf "Creating  ingestion-source type... \n"
#     curl -i -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' -u admin:admin 'http://localhost:21000/api/atlas/v2/types/typedefs' -d @/tmp/model/typedef-ingestion-source.json
#     printf "\ningestion-source created\n"

#     # Setup atlas classification defs
#     printf "Creating file type... \n"
#     curl -i -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' -u admin:admin 'http://localhost:21000/api/atlas/v2/types/typedefs' -d @/tmp/model/typedef-classification.json
#     printf "\nclassifications type created\n"

#     # Setup atlas services
#     printf "Creating  lucasmsp type... \n"
#     curl -i -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' -u admin:admin 'http://localhost:21000/api/atlas/v2/types/typedefs' -d @/tmp/model/typedef-client_process.json
#     printf "\nlucasmsp created\n"
#     sleep 15
#     echo "Done setting up Atlas types "

#     if [ ! -z "${ATLAS_PROVISION_EXAMPLES}" ]; then
#         # Need faketty as otherwise we cannot supply credentials
#         faketty /opt/atlas/bin/quick_start.py http://localhost:21000 < /tmp/credentials | grep 'Sample data added to Apache Atlas Server.'
#         echo "Done provisioning example data"
#     fi


#     if [ ! -z "${ATLAS_KICKSTART_AMUNDSEN}" ]; then
#         # Setup required Amundsen entity definitions
#         printf "Creating Amundsen Entity Definitions... \n"
#         python3 /tmp/init_amundsen.py
#         printf "Amundsen Entity Definitions Created... \n"
#     fi

# else
#     echo "Waited too long for Atlas to start, skipping setup..."
# fi
