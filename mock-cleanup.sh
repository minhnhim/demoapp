echo "*** Cleaning up after mock ***"

# convert the filename back for running on the server
perl -i -pe's/OnmoAuthTriggers/onmoresolver-\$\{env\}-handler/g' amplify/backend/api/OnmoGraphQL/schema.graphql

# convert index.handler path for running on the server
perl -i -pe's/"..\/..\/..\/..\/..\/serverless\/OnmoResolver\/build\/index.handler"/"index.handler"/g' amplify/backend/function/OnmoAuthTriggers/OnmoAuthTriggers-cloudformation-template.json

# comment out "searchable" for local mocking
perl -i -pe's/\# \@searchable/\@searchable/g' amplify/backend/api/OnmoGraphQL/schema.graphql

echo "*** All done ***"