#!/bin/bash

#docker rm /atlas200
docker run --name atlas200 -p 21000:21000 -v $(pwd)/atlas-application.properties:/apache-atlas-2.0.0/conf/atlas-application.properties -d mmiklas/atlas-docker:v2.0.0 
