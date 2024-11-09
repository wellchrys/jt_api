# Setup

If you are using Mac you can run:

```bash
bash bin/setup-macos.sh
```

Make sure the following ports will be available:

- Postgres new: 5432
- Web Application: 4000
- [Swoosh Mailbox](https://github.com/swoosh/swoosh#mailbox-preview-in-the-browser): 4001

Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Format and Credo

```bash
code.check
```

## Tests and Coveralls

```bash
MIX_ENV=test mix coveralls
```

## Environment Variables

| Env                                              | Usage                                                               | Example                                                                                  |
| ------------------------------------------------ | ------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| JUST_POSTGRESQL_URL                               | Primary PostgreSQL connection URL                                   | postgres://postgres:postgres@localhost:5432/just_dev                                      |
| JUST_PHOENIX_SECRET_KEY_BASE                      | Phoenix secret key                                                  | k23kn@K#N@K#N@K#KN2kn32k3                                                                |
| JUST_SELF_HOST                                    | **(PROD ONLY)** app self host                                       | 

## Dotenv

The dotenv will override the env vars in the following order (highest defined variable overrides lower):

| Hierarchy Priority | Filename              | Environment      | Should I `.gitignore`it? | Notes                                             |
| ------------------ | --------------------- | ---------------- | ------------------------ | ------------------------------------------------- |
| 1st (highest)      | `.env.local.$MIX_ENV` | dev/test         | Yes!                     | Local overrides of environment-specific settings. |
| 2nd                | `.env.$MIX_ENV`       | dev/test         | No.                      | Overrides of environment-specific settings.       |
| 3rd                | `.env.local`          | All Environments | Yes!                     | Local overrides                                   |
| Last               | `.env`                | All Environments | No.                      | The Original®                                     |

**Note**: `$MIX_ENV` refers to the environment of the build, as `dev`, `test` and `prod`. Ex: `.env.local.test` will be loaded only when the environment is `test`.

## HeartCheck

Through this endpoint `http://localhost:4000/monitoring/heart-check` you must be able to fetch a payload like this:

```json
[
  {
    "postgresql": {
      "status": "ok"
    },
    "time": 6.187
  }
]
```

## Healt Check

Through this endpoint `http://localhost:4000/monitoring/health-check` you must be able to receive an no-response 204.

## GraphQL

Assuming you already have the API up and running you be able to access [http://localhost:4000/graphiql](http://localhost:4000/graphiql) in your browser
