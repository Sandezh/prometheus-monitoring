## Step 1: Follow these steps for grafana json setup.

1. If you are inside the grafana/dashboards directory

    ```bash
    curl -o blackbox-dashboard.json https://grafana.com/api/dashboards/7587/revisions/2/download
    ```

2. If you are in the root directory

    ```bash
    curl -o grafana/dashboards/blackbox-dashboard.json https://grafana.com/api/dashboards/7587/revisions/2/download
    ```