# Deployment Guide: hackathon.dorg.tech

The hackathon site is served from the dOrg EC2 instance. The same subdomain
(`hackathon.dorg.tech`) serves both the Flutter web dashboard (static files)
and the FastAPI backend (reverse-proxied at `/api/`).

## 1. Netlify DNS Setup

dorg.tech DNS is managed through Netlify. Add an A record pointing the
subdomain to the EC2 public IP.

1. Log into Netlify > **Domains** > `dorg.tech` > **DNS settings**
2. Add a new DNS record:
   - **Type:** A
   - **Name:** hackathon
   - **Value:** 13.48.23.15
   - **TTL:** 3600 (or default)
3. Wait for propagation (~5 min, verify with `dig hackathon.dorg.tech`)

> **Note:** The EC2 does NOT have an Elastic IP. If the instance restarts,
> the IP changes and this record must be updated.

## 2. Build the Flutter Web App

On your local machine:

```bash
cd C:\code\hackathon-app
flutter build web --release --base-href /
```

The built files are in `build/web/`.

## 3. Upload to EC2

```bash
# From local machine
scp -i C:/code/engineer/ec2.pem -r build/web/* \
  ubuntu@ec2-13-48-23-15.eu-north-1.compute.amazonaws.com:/home/ubuntu/hackathon-web/
```

Or create the directory first:

```bash
ssh -i C:/code/engineer/ec2.pem ubuntu@ec2-13-48-23-15.eu-north-1.compute.amazonaws.com \
  "mkdir -p /home/ubuntu/hackathon-web"
```

## 4. Deploy the Backend API

Copy the hackathon Python backend:

```bash
scp -i C:/code/engineer/ec2.pem -r C:/code/hackathon/* \
  ubuntu@ec2-13-48-23-15.eu-north-1.compute.amazonaws.com:/home/ubuntu/hackathon/
```

On the EC2:

```bash
cd /home/ubuntu/hackathon
pip install -r requirements.txt
```

Create a systemd service (`/etc/systemd/system/hackathon-api.service`):

```ini
[Unit]
Description=dOrg Hackathon API
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/hackathon
Environment=HACKATHON_DB_PATH=/home/ubuntu/hackathon/hackathon.db
Environment=HACKATHON_API_HOST=127.0.0.1
Environment=HACKATHON_API_PORT=8000
ExecStart=/usr/bin/python3 -m uvicorn api:app --host 127.0.0.1 --port 8000
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable hackathon-api
sudo systemctl start hackathon-api
```

## 5. Nginx Configuration

Create `/etc/nginx/sites-available/hackathon.dorg.tech`:

```nginx
server {
    listen 80;
    server_name hackathon.dorg.tech;

    # Flutter web app (static files)
    root /home/ubuntu/hackathon-web;
    index index.html;

    # SPA: all non-file routes fall back to index.html
    location / {
        try_files $uri $uri/ /index.html;
    }

    # API reverse proxy
    location /api/ {
        rewrite ^/api/(.*) /$1 break;
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # WebSocket endpoint
    location /ws {
        proxy_pass http://127.0.0.1:8000/ws;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_read_timeout 86400;
    }
}
```

Enable and test:

```bash
sudo ln -s /etc/nginx/sites-available/hackathon.dorg.tech /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## 6. SSL with Certbot

```bash
sudo certbot --nginx -d hackathon.dorg.tech
```

Certbot will modify the nginx config to add SSL redirects automatically.

## 7. Update API Base URL

Before building the Flutter app, update `lib/api_client.dart`:

```dart
const String apiBaseUrl = '/api';  // relative path, same domain
```

This way the Flutter app calls `/api/scores`, `/api/leads`, etc. which Nginx
proxies to the FastAPI backend. No CORS issues since everything is same-origin.

## 8. Verify

- `https://hackathon.dorg.tech/` -- Landing page
- `https://hackathon.dorg.tech/scoreboard` -- Scoreboard
- `https://hackathon.dorg.tech/api/scores` -- API (via Nginx proxy)
- `wss://hackathon.dorg.tech/ws?token=xxx` -- WebSocket

## Quick Redeploy (just the web app)

```bash
cd C:\code\hackathon-app
flutter build web --release --base-href /
scp -i C:/code/engineer/ec2.pem -r build/web/* \
  ubuntu@ec2-13-48-23-15.eu-north-1.compute.amazonaws.com:/home/ubuntu/hackathon-web/
```

No nginx restart needed for static file updates.
