# Self-hosting template for Koalati

Want to spin up your own instance of [Koalati](https://www.koalati.com) 
internally on your own server?

This repository contains everything you need to get started.

To learn more about Koalati's hosted service versus self-hosting, check out 
our [Self-Hosting](https://www.koalati.com/self-hosting) page.

## Getting started

Before you get started, make sure that [Docker](https://www.docker.com/) is 
installed  on your server/machine and that you are familiar with the way Docker 
works.

Then, follow the steps below:

1. Clone this repository:
   ```bash
   git clone https://github.com/koalatiapp/hosting.git koalati
   ```
2. Move into the newly created `koalati` directory:
   ```bash
   cd koalati
   ```
3. Run the initialization script and follow instructions:
   ```bash
   bash initialize-environment.sh
   ```
4. Start the server via `docker-compose`:
   ```bash
   docker-compose up -d
   ```

Once the server is up, you should be able to start using Koalati!
Open [`https://localhost`](https://localhost) in your browser (or whichever 
other hostname you configured), and your own instance of Koalati should be up
and running.

If you run into SSL certificate issues in your browser, check out the [Troubleshooting section](#troubleshooting)
for an easy fix.

However, there's one last thing you should know about: self-hosted instances of 
Koalati are in [invitation-only mode](https://github.com/koalatiapp/app/blob/master/docs/system/self-hosting.md#invitation-only-mode) 
by default. 

This means visitors cannot sign up unless they have been invited by an existing 
user.

To create that first user, use the `create-user` command:

```bash
docker-compose exec php bin/console app:security:create-user
```

And _voilà_! You now have your own instance of Koalati!


## Updating your Koalati installation

Every once in a while, you'll want to update your self-hosted instance of 
Koalati to get the latest features, improvements and bugfixes.

To do that, first make sure your `KOALATI_VERSION` variable is set to `latest`
in the `.env` file.

Then, make sure your hosting configs are up to date:
```
git pull
```

Finally, run the following commands to update:

```bash
docker-compose down --remove-orphans
docker-compose pull php
docker-compose pull caddy
docker-compose pull tools-service
docker-compose up -d
```

## Self-hosting specific changes

To learn about self-hosting specific changes, check out our [self-hosting documentation](https://github.com/koalatiapp/app/blob/master/docs/system/self-hosting.md#invitation-only-mode) 
on Koalati's main repository.

## Security

- Invitation-only mode is enabled by default.
  - This is done as a security measure to prevent people discovering your 
    internal Koalati instance and abusing it. 
  - If your internal Koalati instance is protected via some other security 
    measure (VPN, .htpasswd, etc.), you may disable this mode.

## Troubleshooting
### ⚠️ Untrusted SSL certificate issues

If you have a TLS trust issues when running Koalati on your local machine, you 
can copy the self-signed certificate from Caddy and add it to the trusted 
certificates by running the command for your OS below from within the `koalati`
directory. 

You may have to restart your browser after running the command for this change 
to take effect.

#### Mac
```bash
docker cp $(docker compose ps -q caddy):/data/caddy/pki/authorities/local/root.crt /tmp/root.crt && sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /tmp/root.crt
```

#### Linux
```bash
docker cp $(docker compose ps -q caddy):/data/caddy/pki/authorities/local/root.crt /usr/local/share/ca-certificates/root.crt && sudo update-ca-certificates
```

#### Windows
```bash
docker compose cp caddy:/data/caddy/pki/authorities/local/root.crt %TEMP%/root.crt && certutil -addstore -f "ROOT" %TEMP%/root.crt
```

### ⚠️ Docker Compose hangs without outputting anything

This is a common issue with `docker-compose` on VPS with limited resources.

First, run the following command:

```bash
cat /proc/sys/kernel/random/entropy_avail
```

If the output is less than 1000, that is almost certainly why it's hanging. 

If that's the case for you, you can fix the issue by simply installing `haveged` on your VPS:

```bash
apt install haveged
```

Thanks to [Phillip Elm's suggestion on StackOverflow](https://stackoverflow.com/a/68172225/2327027)
for this fix.


## Advanced configurations

If you feel adventurous, you can open and edit your `.env` and `docker-compose.yaml` 
files as you see fit to configure your Koalati environment to your liking.

For example, you could:
- Disable Caddy's automatic HTTPS configuration by changing the `SERVER_NAME` variable.
- Run Koalati on a different port by editing the `docker-compose.yaml`.
- Use an external MySQL database instead of using the Docker-managed one.
- Run the tools service externally on a more scalable infrastructure for improved performance.


## Contributing

Think something can be improved? Submit a PR or open an issue here on GitHub!

If you have an issue with this hosting template, submit your PR/issue in this 
repository.

If your issue or suggestion is about the app itself, you're likely looking for 
the [`app`](https://github.com/koalatiapp/app) repository. 

You can also check  out the rest of the repositories that help run Koalati on 
[Koalati's GitHub profile](https://github.com/koalatiapp).
