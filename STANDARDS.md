# Code standards

_[<- back to README](README.md)_

1. [Principles](#principles)
2. [Project structure](#project-structure)
   1. [`amplify/`](#amplify)
   2. [`serverless/OnmoLogAlert/`](#serverlessonmologalert)
   3. [`serverless/OnmoResolver/`](#serverlessonmoresolver)
3. [Comments](#comments)

> :warning: _**WIP**: The current state of the codebase might not reflect the standards outlined in this document._

---

## Principles

- Keep your code **DRY** (Don't Repeat Yourself).
- A single function/method/class should be responsible of "one thing" (see [single-responsibility principle](https://stackify.com/solid-design-principles/)). Following this principle makes tests easier to write, logic easier to follow, and code easier to extend and modify in the future - all factors contributing to less bugs. The more responsibility a single unit of code has, the harder it is to modify to follow shifting requirements, and the more likely it is tests on this block of code will break with every change.

## Project structure

### `amplify/`

AWS Amplify code, including graphql schema.

### `serverless/OnmoLogAlert/`

Sends notifications to Slack channel.

### `serverless/OnmoResolver/`

Main resolver code. To provide separation of concerns, we mainly use three abstraction layers (controllers/services/models) for the main application flows.

- **`index.ts`**: Dispatcher code. Takes requests and dispatches to controllers, rate limiting, etc.
- **`src/`**
  - **`models/`**: We call them "models" but they're more akin to DAO. Abstracts data read/write calls.
  - **`services/`**: Business logic. Actual implementation of the logical steps called by controllers, doing data persistence through models.
  - **`controllers/`**: Application logic. Permission checks, user input validation, chaining service calls, and building/sending responses.
  - **`clients/`**: Clients for external services. Should be mostly used in the service/DAO layer.
  - **`tasks/`**: Scheduled tasks related code.
  - **`utils/`**: Various utility functions/classes.
  - **`constants.ts`**: Constant values used throughout the codebase.
  - **`util.ts`**: Dangling utilities (refactor into the `utils/` directory still TODO).

> :warning: This structure is subject to change, especially when e.g. the switch to an Apollo server happens, controllers would be converted to resolvers.

## Comments

We use JSDoc to document the _purpose_ of the documented class/function, and the _meaning_ of parameters. Prefer good parameter names to redundant descriptions.

Bad:

```typescript
/**
 * Update a user
 * @param {string} userId - The user id
 * @param {Partial<IUser>} data - The data
 * @async
 * @returns {Promise<IUser>} - The user
 */
async function updateUser(userId: string, data: Partial<IUser>): Promise<IUser> {
  // [update the user state]
  return user;
}
```

Better:

```typescript
/**
 * Update a user's information in the database
 * @param {string} userId
 * @param {Partial<IUser>} userInfo
 * @async
 * @returns {Promise<IUser>} - The updated user
 */
async function updateUser(userId: string, userInfo: Partial<IUser>): Promise<IUser> {
  // [update the user state]
  return user;
}
```

Outside JSDoc, comments should usually explain the _why_ over the _what_. Explain _why_ something works the way it does rather than _what_ the code is doing. Name everything something descriptive and obvious. Comments are not a substitute for bad naming and design. Make your code as obvious and the logic as easy to follow as possible, _then_ consider adding comments if things are still not easy to understand or if required steps can't be broken down and need some explanation.
