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

## Updating your Koalati installation

```bash
docker-compose down --remove-orphans
docker-compose pull koalati/app-php
docker-compose pull koalati/app-caddy
docker-compose pull koalati/tools-service
docker-compose up -d
```


## To-Do
- @TODO: Automatically create tools service tables if they don't exist yet
- @TODO: Add local file storage support
- @TODO: Add a local meta fetcher in PHP and use it as the default for self-hosting 


## Contributing

Think something can be improved? Submit a PR or open an issue here on GitHub!

If you have an issue with this hosting template, submit your PR/issue in this 
repository.

If your issue or suggestion is about the app itself, you're likely looking for 
the [`app`](https://github.com/koalatiapp/app) repository. 

You can also check  out the rest of the repositories that help run Koalati on 
[Koalati's GitHub profile](https://github.com/koalatiapp/hosting).