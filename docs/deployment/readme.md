# Documentation for the deployment

This documentation is for the Banana Pi that is used as Server.

#### prerequisite

- Go through server-config file in order to setup the server properly.
- Add SSH to the server for github


#### Basic Capistrano commands for deployments:

```
bin/cap production git:check  
bin/cap production deploy:check  
bin/cap production deploy

```

