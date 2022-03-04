# Running Local Backend (Amplify Mock)

## SETUP

### Amplify

Make sure you have installed:

```toml
npm install -g serverless
npm install -g @aws-amplify/cli
```

In the `stealth-backend` folder, run:

```toml
npm ci
npm install boto
saml2aws login --profile onmo-dev
amplify init
```

### DynamoDb-admin

In order to be able to view the local DynamoDb database, install:

```toml
npm install -g dynamodb-admin
```

Once amplify mock is running, you can access the DynamoDb data by running: (`note`: This is all one line)

```toml
AWS_REGION=us-fake-1 AWS_ACCESS_KEY_ID=fake AWS_SECRET_ACCESS_KEY=fake DYNAMO_ENDPOINT=http://localhost:62224 dynamodb-admin --port 8000 --open
```

### MySQL

Install and run a local mysql server, for example:

```toml
brew install mysql
mysql.server start
```

Set up the root username and password:

```toml
mysql
CREATE USER 'root'@'localhost' IDENTIFIED BY 'abc123';
GRANT ALL PRIVILEGES ON * . * TO 'root'@'localhost';
```

Start the MySQL server, and create a table named `onmo`.

Import the database:

```toml
mysql -u root -pabc123 onmo < mock-tools/dumpfile.sql
```

### Redis

Install and run a local redis server, for example

```toml
brew install redis
redis-server
```

<br />

### RUNNING AMPLIFY MOCK

Once everything is installed, run:

```toml
./mock-amplify.sh
```

This script makes changes to the code in order to run amplify locally, then restores the code when terminated normally. `If the script is killed (e.g. control-c), the cleanup code will not run.` To terminate normally, let the script run fully so that amplify mock is runnning, then press "enter" in the terminal when prompted, and the script will perform its cleanup code. If you kill the script, be sure to run it again and allow it to run the cleanup code.

`Notes:`<br/>

<ul>
<li>The first time you run `mock amplify`, you will want to choose "Y" when prompted to import DynamoDb data. You only need to run this code again if you want to clean out and restore the data.</li>

<li>You will need to rebuild and mock the OnmoAuthTrigger function once per session by choosing "Y" when prompted.</li>

<li>Once `amplify mock` is running, you can view the query browser at `http://localhost:20002`</li>

</ul>

<br/>
<br/>

## RUNNING THE FRONT END LOCALLY

Download `stealth` from GitHub

```toml
github repo clone B2tGame/stealth
```

Install dependencies:

```toml
npm i
npm install node-pre-gyp
```

In src/aws-exports.js:<br />

```toml
Replace both occurences of: https://dev.onmostealth.com/
With https://localhost:3000/

Replace: https://qgt775bmejdcxfkidvudqnzh4y.appsync-api.us-east-1.amazonaws.com/graphql
With: http://localhost:20002/graphql (note the "http", `not` "https")
```

In the stealth directory, create a `.env` file containing:

```toml
REACT_APP_FACEBOOK_CLIENT_ID=641088706509792
REACT_APP_LOGIN_EMAIL=true
REACT_APP_LOGIN_GUEST=true
```

<br />
Now you can start up the front end:

```toml
npm start
```

`Notes`:

<ul>
<li>Only the `MOBILE` login appears to work locally.</li>
<li>Games will run, but will not be able to calculate the final score.</li>
<li>Leaderboards will not show up as there is no data in the redis server</li>
</ul>
