# vps-setup

My scripts for setup VPS

- OS: CentOS 8

## Usage

```bash
$ cp .env.sample .env
$ vi .env
# edit config
$ ./prepare.sh
```

## Features

- Create new user
- Add public RSA key
- Disable root login
- Change SSH port
- Modify Firewall setting (SSH, HTTP, HTTPS)
- Modify SELinux
- Disable password authentication
- Certbot
