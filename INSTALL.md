# EasyFile — Installation Guide

## Prerequisites

- Elixir 1.15 or later
- OTP 26 or later

## Quick Install

Run the single install script:

```bash
bash install.sh
```

This script performs the following steps:
1. Installs Hex and Rebar (non-interactively)
2. Fetches and compiles all dependencies
3. Creates the SQLite database
4. Runs database migrations
5. Seeds demo data (user + sample uploads)
6. Compiles the application

The install script is idempotent — safe to run multiple times.

## Manual Install

If you prefer to run each step individually:

```bash
# 1. Install Hex and Rebar
mix local.hex --force
mix local.rebar --force

# 2. Get dependencies
mix deps.get

# 3. Set up the database
mix ecto.create
mix ecto.migrate

# 4. Seed demo data
mix run priv/repo/seeds.exs

# 5. Compile
mix compile
```

## Starting the Server

```bash
mix phx.server
```

The application will be available at **http://localhost:4000**.

## Demo Account

| Email            | Password | Notes                     |
|------------------|----------|---------------------------|
| cenius@cenius.ai | cenius   | Primary demo user with sample files |

## Environment Variables

| Variable          | Default                          | Description                  |
|-------------------|----------------------------------|------------------------------|
| `PORT`            | `4000`                           | HTTP server port             |
| `SECRET_KEY_BASE` | (dev default in config)          | Required for production      |
| `PHX_HOST`        | `example.com`                    | Production hostname          |
| `PHX_SERVER`      | (unset)                          | Set to `true` for production |

## Testing

```bash
mix test
```
