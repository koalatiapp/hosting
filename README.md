# Self-hosting template for Koalati

Want to spin up your own instance of [Koalati](https://www.koalati.com) 
internally on your own server?

This repository contains everything you need to get started.

To learn more about Koalati's hosted service versus self-hosting, check out 
our [Self-Hosting](https://www.koalati.com/self-hosting) page.

## Getting started

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

However, there's one last thing you should know about: self-hosted instances of 
Koalati are in [invitation-only mode](https://github.com/koalatiapp/app/blob/master/docs/system/self-hosting.md#invitation-only-mode) 
by default. 

This means visitors cannot sign up unless they have been invited by an existing 
user.

To create that first user, use the `create-user` command:

```bash
docker-compose exec php bin/console app:security:create-user
```

And voilà! You're not 

## Updating your Koalati installation

Every once in a while, you'll want to update your self-hosted instance of 
Koalati to get the latest features, improvements and bugfixes.

To do that, first make sure your `KOALATI_VERSION` variable is set to `latest`
in the `.env` file.

Then, run the following commands to update:

```bash
docker-compose down --remove-orphans
docker-compose pull koalati/app-php
docker-compose pull koalati/app-caddy
docker-compose pull koalati/tools-service
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

## Contributing

Think something can be improved? Submit a PR or open an issue here on GitHub!

If you have an issue with this hosting template, submit your PR/issue in this 
repository.

If your issue or suggestion is about the app itself, you're likely looking for 
the [`app`](https://github.com/koalatiapp/app) repository. 

You can also check  out the rest of the repositories that help run Koalati on 
[Koalati's GitHub profile](https://github.com/koalatiapp/hosting).