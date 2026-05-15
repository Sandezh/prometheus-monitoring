# 📖 How-To Guide

This guide provides detailed instructions for common tasks in the monitoring stack.

## 🚀 Quick Access Reference

| Service | Port | Local URL |
|---------|------|-----------|
| **Prometheus** | 9090 | [http://localhost:9090](http://localhost:9090) |
| **Alertmanager** | 9093 | [http://localhost:9093](http://localhost:9093) |
| **Grafana** | 3001 | [http://localhost:3001](http://localhost:3001) |
| **Blackbox** | 9115 | [http://localhost:9115](http://localhost:9115) |

---

## 🎯 How to Add New Monitoring Targets

The stack uses **File Service Discovery**. You don't need to restart Prometheus to add new websites or services.

### 1) Manual Approach (File Management)

1.  Open the `targets/` directory.
2.  Create a new `.yml` file by copying the example: `cp targets/targets.example.yml targets/targets.yml`.
3.  Edit [targets.yml](file:///c:/Users/DELL/Desktop/prometheus/targets/targets.yml) or create a new one (e.g., `targets/my-apps.yml`).
4.  Add your targets in the following format:
    ```yaml
    - targets:
        - https://my-new-site.com
        - https://api.my-app.com
      labels:
        env: production
        team: backend
    ```
5.  Prometheus will automatically detect the changes within 2 minutes (configured by `refresh_interval`).

### 2) Automated Approach (CLI & Auto-Discovery)

#### A. Using the Command Line (Local/Manual)
You can manage targets without opening the YAML file using the provided helper script:

**Windows (PowerShell):**
```powershell
# Add a target
.\manage-targets.ps1 -Action add -URL "https://my-app.com" -Env "production"

# Remove a target
.\manage-targets.ps1 -Action remove -URL "https://my-app.com" -Env "production"

# List all targets
.\manage-targets.ps1 -Action list
```

**Linux/macOS (Bash):**
```bash
# Add a target
./manage-targets.sh add https://my-app.com production

# Remove a target
./manage-targets.sh remove https://my-app.com production

# List all targets
./manage-targets.sh list
```

#### B. Using AWS Auto-Discovery (Fully Dynamic)
For AWS environments, you can configure Prometheus to automatically discover instances based on tags. This eliminates the need to manually manage IP addresses or URLs.

- **How it works**: Prometheus queries the AWS API and **only monitors** instances that have the tag `monitor: true`.
- **Setup**: Uncomment the `aws-ec2-discovery` section in [prometheus.yml](file:///c:/Users/DELL/Desktop/prometheus/prometheus.yml) and ensure your EC2 instance has the `AmazonEC2ReadOnlyAccess` IAM policy.

---

## 🚨 How to Configure Alerts

### 1. Discord Alerts
1.  Go to your Discord Server Settings -> Integrations -> Webhooks.
2.  Create a new webhook and copy the URL.
3.  Paste it into the `DISCORD_WEBHOOK` variable in your [.env](file:///c:/Users/DELL/Desktop/prometheus/.env) file.

### 2. Slack Alerts
1.  Create an "Incoming Webhook" in your Slack workspace.
2.  Copy the URL.
3.  Paste it into the `SLACK_WEBHOOK` variable in your [.env](file:///c:/Users/DELL/Desktop/prometheus/.env) file.
4.  Restart the stack: `docker-compose up -d`.
    *The system automatically handles the Slack configuration using the environment variable from your .env file.*

---

## 📊 How to Add Grafana Dashboards

### Adding via UI
1.  Log in to Grafana at [http://localhost:3001](http://localhost:3001).
2.  Go to **Dashboards** -> **Import**.
3.  Enter a dashboard ID from [Grafana Labs](https://grafana.com/grafana/dashboards/) (e.g., `7587` for Blackbox Exporter) or upload a JSON file.

### Adding via Provisioning (Persistent)

1. Place your dashboard JSON file in the `grafana/dashboards/` directory.
2. It will be automatically loaded by Grafana on startup.

#### Step 1: Follow these steps for Grafana JSON setup

- **If you are inside the `grafana/dashboards` directory:**
  ```bash
  curl -o blackbox-dashboard.json https://grafana.com/api/dashboards/7587/revisions/2/download
  ```

- **If you are in the project root directory:**
  ```bash
  curl -o grafana/dashboards/blackbox-dashboard.json https://grafana.com/api/dashboards/7587/revisions/2/download
  ```

---

## 🧹 Maintenance & Troubleshooting

### Viewing Logs
To see what's happening in your containers:
```bash
docker-compose logs -f [service_name]
# Example: docker-compose logs -f prometheus
```

### Resetting Data
To clear all stored metrics and start fresh:
```bash
docker-compose down -v
```

### Checking Config Validity
If you change `prometheus.yml` or `alertmanager.yml`, you can check for syntax errors:
```bash
docker-compose exec prometheus promtool check config /etc/prometheus/prometheus.yml
docker-compose exec alertmanager amtool check-config /etc/alertmanager/alertmanager.yml
```
