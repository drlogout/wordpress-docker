# wordpress-docker

From the wordpress docker image it's not possible to send emails e.g. password resets, notifications about new comments, ...
This image installs postfix and configures it as a relay server at runtime.


```yml

version: "2"

services:
  web:
    build: .
    environment:
      SMTP_HOST: mail.example.com # required
      SMTP_PORT: 587 # optional, default 587
      SMTP_USER: wordpress-sites@example.com # required, must be an email address
      SMTP_PASSWORD: rkA3npiwqDzjcszFBZYwiAftvm2PMFWC # required
      SMTP_FROM_NAME: fancy-wordpress-site.com # optional, default is hostname
      ROOT_FORWARD: admin@example.com # required
      CONTAINER_HOSTNAME: fancy-wordpress-site.com # required, must be equal to hostname to verify the hostname is set via docker run
      FORCE_CONFIG: "yes" # optional, forces reconfiguration
    hostname: fancy-wordpress-site.com # required, e.g. the domain of the wordpress site
    volumes:
      - ./wp:/var/www/html
    ports:
      - 8888:80
      
  mysql:
    image: mysql:5.7
    environment: 
      MYSQL_ROOT_PASSWORD: owUh6LkkCNhwyvwrQWtV7gVudrpZbKVY
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: hVKK8q8TfpXHdPJFqiXfTWkykvBPjhQf

```

After postfix is configured, the configurarion is skipped at the next container start. To force a reconfiguration set the `FORCE_CONFIG` environment variable to `yes`.
