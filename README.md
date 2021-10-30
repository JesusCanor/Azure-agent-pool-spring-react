# Self hosted agent pool for spring and react project (java, maven and nodejs instaled)

This project can be used to setup a docker self-hosted Azure agent. It will
start an Ubuntu 18.04 Linux self-hosted agent in a docker container.

---
## Prerequisites

+ git
+ Docker
+ docker-compose

---

## Installation Steps:

+ Clone the this project repository:

+ Edit the values in azureConfig.env with your data from azure Accounts.

    - Use your own token| -> User settings -> Personal access tokens.
      The public access token needs the following custom scopes accessible by
      choosing "Show all scopes".

    - Scopes:
        * Agent Pools (Read & manage)
        * Deployment Groups (Read & manage)

+ Start the agent with
    - ```bash
         docker-compose build --pull
         docker-compose up -d```
