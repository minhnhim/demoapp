# Onmo

> :eyes: Also see _[testing](TESTING.md) and [coding standards](STANDARDS.md)_

- [Onmo](#onmo)
  - [Getting started](#getting-started)
    - [Install and configure dependencies](#install-and-configure-dependencies)
    - [Setup the project](#setup-the-project)
    - [Deployment](#deployment)
  - [Tests](#tests)
    - [Existing test suites](#existing-test-suites)
    - [Run test suite(s)](#run-test-suites)
  - [Git/Github](#gitgithub)
    - [Naming branches](#naming-branches)
    - [Pull requests](#pull-requests)

---

## Getting started

### Install and configure dependencies

1. Install [git](https://git-scm.com/downloads)
2. Install [docker](https://docs.docker.com/get-docker) (w/ docker-compose)
3. Install [npm](https://www.npmjs.com/get-npm), then `npm install -g` packages:
   - [serverless](https://www.serverless.com/framework/docs/getting-started/)
   - [amplify](https://docs.amplify.aws/cli/start/install)
4. Install [saml2aws](https://github.com/Versent/saml2aws)
   - Once you ran `saml2aws` and configured it, you can edit the `~/.saml2aws` config file and set the value of `aws_session_duration` to 43200. This will keep your session token usable for 12 hours, preventing you to have to refresh it more than once a work day.
5. Create the aws config (`~/.aws/config`) and insert the profile settings:

   ```toml
   [onmo-dev]
   region=us-east-1

   [onmo-staging]
   region=us-east-1

   [onmo-prod]
   region=ap-south-1
   ```

### Setup the project

1. Clone the repository
   ```sh
   git clone git@github.com:B2tGame/stealth-backend.git
   ```
2. Go to your console and select your project directory.
3. Install the project node package from the project root
   ```sh
   npm install
   ```
4. Init amplify fromt the project root
   ```sh
   amplify init
   ```

### Deployment

1. You must to connect your profile to aws with saml2aws
   ```sh
   saml2aws login --profile onmo-dev
   ```
   profile can be either of `onmo-dev`, `onmo-staging` or `onmo-prod`
2. Enter your username (b2tgame email) and google account password
3. Choose the role `SSO.amplify.admin` (ask Ivan to give you the necessary AWS permissions)
4. To deploy only OnmoResolver (parameter can be `dev`, `staging` or `prod`)
   ```sh
   ./deploy.sh dev
   ```
5. To deploy OnmoResolver and amplify (parameter can be `dev`, `staging` or `prod`)
   ```sh
   ./deploy.sh dev full
   ```

---

## Tests

We use `jest` to run our unit and integration tests (in combination with `docker`/`docker-compose` for database images for the latest). See our [testing](TESTING.md) documentation for guidelines.

### Existing test suites

- `amplify/backend/function/OnmoAuthTriggers`
  - unit tests
- `serverless/OnmoResolver`
  - unit tests
  - integration tests
  - legacy: **Deprecated**. This was a mix of unit and integration-like tests running against a real database. The suite was unfortunately too brittle and difficult to work with. No new tests should go in there - **PRs containing new tests in this suite will get declined**. If tests break in there, evaluate if they are still relevant. If yes, try converting them to a unit test first.

### Run test suite(s)

- To run all tests (same as CI), run `npm run test` from the root directory. To run a subset of tests, you can directly run `npm run test:unit` or `npm run test:integration`, which are what the main script calls.
- You can run tests directly from subproject directories too - debugging output is not muted from there.

---

## Git/Github

### Naming branches

- The project is using the [GitFlow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) convention, using the `develop` branch as our main. By this convention, we prefix branch names with either one of `feature/...`, `hotfix/...` or `release/...` (e.g. `hotfix/foo`).
- A branch must have in its name the JIRA task ID, followed by an optional (and preferably short) descriptor. Example, for a bug ticket named `STL-1234 - Fix foobar error`, the branch could be named `feature/STL-1234` or something like `feature/STL-1234-foobar-error`.

### Pull requests

- You must use Pull Requests to get code merged to `develop`.
- Add descriptions to your PRs explaining the what and why of the changes, _especially_ for non-trivial changes.
- Fill out the PR checklist template to help everyone make sure that your PR is ready for review.
- PRs are not the place to discuss about the ins and outs of a non-trivial feature should have been designed. If this happens, some discussions should have happened before even typing a single line of code.
- We won't merge a branch that is not currently up to date with `develop`.
- PRs necessitate at least one review before merging.
- It is assumed a branch is not ready for review if checks are failing.
- Use the JIRA task ID and title as the PR's title (if applicable)
- We recommend fully using Github's functionality around PRs to ensure everyone gets notified, notably:
  - Use draft PRs for work in progress that you wish to expose.
  - Add people as reviewers when creating new PRs.
  - Re-request review from the sidebar after addressing comments.
- We squash commits before merging, but proper commits (both in content and message) makes PRs easier to review. It can be hard for a reviewer to properly grasp what you were trying to do if your commit history gets too messy.
- Keep PRs focused, make the minimum amount of changes you can, and make changes unrelated to your feature/fix in a separate PR.
