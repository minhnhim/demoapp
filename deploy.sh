#!/bin/bash

if [ -z "$1" ]
  then
    echo "No environment selected"
    exit 1
fi

if [ $1 == "dev" ]
then
    git pull origin develop
fi

if [ $1 == "prod" ]
then
    read -p "Do you want to deploy on production ? (y/N) " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "\n"
    else

        exit 1
    fi
fi

SLACKDATA='{"text":" '$USER' - Backend deployment '
SLACKDATA=$SLACKDATA$1' START"}'
curl -X POST -H 'Content-type: application/json' --data "$SLACKDATA" https://hooks.slack.com/services/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

npm ci

cd serverless/OnmoResolver
serverless deploy --env $1 --aws-profile onmo-$1

if [ $1 == "prod" ]
then
    cd ../OnmoSingaporeSync
    serverless deploy --aws-profile onmo-$1
fi

if [ -z "$2" ]
  then
    SLACKDATA='{"text":" '$USER' -Backend deployment '
    SLACKDATA=$SLACKDATA$1' FINISH"}'
    curl -X POST -H 'Content-type: application/json' --data "$SLACKDATA" https://hooks.slack.com/services/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
else
    if [ $2 == "full" ]
    then
        cd ../..

        if [ $1 == "prod" ]
        then
            amplify env checkout prodindia
        else
            amplify env checkout $1
        fi
        amplify push
        SLACKDATA='{"text":" '$USER' - Backend deployment '
        SLACKDATA=$SLACKDATA$1' FINISH"}'
        curl -X POST -H 'Content-type: application/json' --data "$SLACKDATA" https://hooks.slack.com/services/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
    fi
fi

read -p "Press [Enter] key to close..."