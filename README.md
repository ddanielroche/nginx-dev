### Dockerized Reverse Proxy

This repository contains a Dockerized Nginx reverse proxy setup for local development, utilizing mkcert to generate trusted SSL certificates.
The setup allows you to run multiple local services with HTTPS support without browser warnings.

### Prerequisites
- Docker and Docker Compose installed on your machine.
- mkcert installed for generating local SSL certificates.
- Make for running the setup and launching the reverse proxy.

### Setup Instructions
- Clone this repository to your local machine.
- Navigate to the cloned directory.
- Run the following command to install mkcert (Debian/Ubuntu), On another system, you can see the official documentation of [mkcert](https://github.com/FiloSottile/mkcert)

```bash
sudo apt install mkcert
```

- Generate the local CA and install it in your system's trust store:
```bash
make cert
```

- Create `dev.local` docker network:
```bash
docker network create dev.local
```

- Launch the reverse proxy:
```bash
make up
```

- Access the reverse proxy at `https://dev.local` in your web browser.

If you want to add more proxy configurations, you can create a new file in the `conf.d` directory and add your service configurations there.
The reverse proxy will automatically pick up the new configurations.

### Example Service Configuration
You can add a new service configuration in the `conf.d` directory. For example, to add a service running on port 3000,
create a file named `my_service.conf` with the following content:

```nginx
server {
    listen 80;
    server_name my_service.dev.local;
    
    # Redirect all HTTP traffic to HTTPS
    location / {
        return 301 https://$host$request_uri;
    }
}
server {
    listen 443 ssl;
    server_name my_service.dev.local;

    ssl_certificate /etc/nginx/certs/dev.local.crt;
    ssl_certificate_key /etc/nginx/certs/dev.local.key;

    location / {
        proxy_pass http://my_service:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

After creating the configuration file, you can add the new DNS entry to your `/etc/hosts` file:

Finally, you can access your service at `https://my_service.dev.local` in your web browser.
