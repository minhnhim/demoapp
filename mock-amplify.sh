#!/bin/bash

# make sure this is running in the right directory
result=$(pwd | grep stealth-backend)
if [[ $result != *"stealth-backend"* || $result == *"stealth-backend/"* ]]; then
  echo "You need to run this script from the stealth-backend directory"
fi 

echo "*** Modifying code files for mocking ***"
echo

# convert the function name for local mocking
perl -i -pe's/onmoresolver-\$\{env\}-handler/OnmoAuthTriggers/g' amplify/backend/api/OnmoGraphQL/schema.graphql

# comment out "searchable" for local mocking
# (first make sure it isn't already commented out)
perl -i -pe's/\# \@searchable/\@searchable/g' amplify/backend/api/OnmoGraphQL/schema.graphql
perl -i -pe's/\@searchable/\# \@searchable/g' amplify/backend/api/OnmoGraphQL/schema.graphql

# convert index.handler path for local mocking
perl -i -pe's/"index.handler"/"..\/..\/..\/..\/..\/serverless\/OnmoResolver\/build\/index.handler"/g' amplify/backend/function/OnmoAuthTriggers/OnmoAuthTriggers-cloudformation-template.json

# create or replace .env file
rm amplify/backend/function/OnmoAuthTriggers/.env
echo 'REGION=us-fake-1
USER_TABLE=UserTable
MOMENT_TABLE=MomentTable
APP_TABLE=AppTable
USER_ACTIVITY_TABLE=UserActivityTable
USER_APP_STATS_TABLE=UserAppStatsTable
USER_MOMENT_STATS_TABLE=UserMomentStatsTable
FRIEND_TABLE=FriendTable
GAMESESSION_TABLE=GameSessionTable
NOTIFICATION_TABLE=NotificationTable
SNAPSHOT_TABLE=SnapshotTable
STORE_ITEMS=StoreItemsTable
STREAM_RATING=StreamRatingTable
DB_HOST=localhost
DB_USER=root
DB_PWD=abc123
DB_NAME=onmo
STAGE=dev
IS_MOCKING=true' > amplify/backend/function/OnmoAuthTriggers/.env

# create event.json file if it doesn't already exist
if ! test -f "amplify/backend/function/OnmoAuthTriggers/src/event.json"; then
    echo '{}' > amplify/backend/function/OnmoAuthTriggers/src/event.json
fi

# compile the code
echo
echo "*** Compiling ***"
cd serverless/OnmoResolver
npm run build
cd ../..

# ask if we need to mock
echo
echo "Do you want to rebuild and mock the OnmoAuthTrigger function? [y/N]"
read function_yn

if [[ $function_yn == "Y" || $function_yn == "y" ]]; then
  # mock the function
  echo
  echo "*** Mocking function OnmoAuthTriggers ***"
  echo "*** (ignore 'Event not supported' error message below) ***"
  amplify mock function OnmoAuthTriggers --event "src/event.json"
fi

# run amplify mock
amplify mock api &
process_id=$!

# wait for amplify to start
echo "*** (ignore 'Event not supported' error message above) ***"
echo "*** Starting amplify mock ***"
sleep 3
echo "."
sleep 3
echo ".."
sleep 3
echo "..."
sleep 3
echo "...."
sleep 3
echo "....."
sleep 3
echo "......"
sleep 3
echo "......."
sleep 3
echo "........"
sleep 3
echo "........."

# ask if user wants to import DynamoDb
echo
echo "Do you want to import DynamoDb data? [y/N]"
read import_yn
if [[ $import_yn == "Y" || $import_yn == "y" ]]; then
  cd mock-tools
  ./dynamo-import.sh
  cd ..
fi

# wait for amplify mock to end
echo "****************************************************"
echo "Amplify Mock is now running on http://localhost:20002/"
echo "To rebuild without quitting, run 'npm run build' or choose 'Run build task...' from the Terminal window menu in Visual Studio Code."
echo
echo "NOTE: When you want to stop the server and clean up the files, press ENTER in this terminal."
read
kill $process_id

echo "*** Cleaning up after mock ***"

# convert the filename back for running on the server
perl -i -pe's/OnmoAuthTriggers/onmoresolver-\$\{env\}-handler/g' amplify/backend/api/OnmoGraphQL/schema.graphql

# convert index.handler path for running on the server
perl -i -pe's/"..\/..\/..\/..\/..\/serverless\/OnmoResolver\/build\/index.handler"/"index.handler"/g' amplify/backend/function/OnmoAuthTriggers/OnmoAuthTriggers-cloudformation-template.json

# comment out "searchable" for local mocking
perl -i -pe's/\# \@searchable/\@searchable/g' amplify/backend/api/OnmoGraphQL/schema.graphql

echo "*** All done ***"

