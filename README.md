# Prometheus Monitoring Stack

A comprehensive, flexible, and production-ready monitoring stack using Prometheus, Alertmanager, and Grafana. This setup features dynamic service discovery and multi-channel alerting, and is fully compatible for both **AWS** and **local** environment monitoring.

## 🏗️ Architecture

- **Prometheus**: Core monitoring system for metric collection and storage.
- **Alertmanager**: Handles alerts sent by Prometheus and routes them to Discord/Slack.
- **Blackbox Exporter**: Probes endpoints (HTTP, HTTPS, DNS, TCP, ICMP) to monitor availability.
- **Node Exporter**: Collects hardware and OS metrics from host machines.
- **cAdvisor**: Provides resource usage and performance characteristics of running containers.
- **Grafana**: Visualization platform for metrics.
- **Alertmanager-Discord**: A bridge to send Alertmanager notifications to Discord.

## 🚀 Quick Start

### 1. Prerequisites
- Docker and Docker Compose installed.

### 2. Configuration
Copy the template files and fill in your actual values (webhooks, credentials, targets):
```bash
cp .env.example .env
cp targets/targets.example.yml targets/targets.yml
```

## 🏁 Step-by-Step Setup

### Step 1: Running the Monitoring Stack

1. Start all services:
    ```bash
    docker-compose up --build -d
    ```

### Step 2: Access Prometheus

1. 📊 **Query Interface**: [http://localhost:9090](http://localhost:9090)
2. 🎯 **Targets Page**: [http://localhost:9090/targets](http://localhost:9090/targets)

### Step 3: Access AlertManager

1. 🚨 **Alerts Dashboard**: [http://localhost:9093](http://localhost:9093)

### Step 4: Access Grafana

1. 📈 **Grafana UI**: [http://localhost:3001](http://localhost:3001)
   
   Once inside the Grafana dashboard:
   - Navigate to the **Dashboards** sidebar.
   - Click on your dashboard (e.g., **website-monitoring-dashboard**) to see the metrics visualization.

---

## 🔗 Service Summary Table

| Service | URL | Description |
|---------|-----|-------------|
| **Prometheus** | [http://localhost:9090](http://localhost:9090) | Query metrics and view targets |
| **Alertmanager** | [http://localhost:9093](http://localhost:9093) | Manage and silence alerts |
| **Grafana** | [http://localhost:3001](http://localhost:3001) | Dashboards and visualization |
| **Blackbox Exporter** | [http://localhost:9115](http://localhost:9115) | Probe status and logs |

## 🛠️ Management

- **Add Targets**: Add or edit `.yml` files in the `targets/` directory. Prometheus will pick them up automatically.
- **Alerts**: Configure Discord and Slack webhooks in the `.env` file and `alertmanager.yml`.
- **Dashboards**: Grafana is pre-provisioned with dashboards in `grafana/dashboards/`.
