# Let's dive into the docker compose manifest
code docker-compose.yaml


# Start up our monitoring stack using docker compose
docker compose up --detach


# Check to ensure everything is up and running
docker ps


# Let's first look at the metrics being collected from SQL Server by Telegraf
open http://localhost:9273/metrics 


# Quick review of the telegraf configuration for the SQL Server plugin
code ./telegraf/telegraf.conf



# Let's look at the prometheus configuration file
code ./prometheus/prometheus.yml


# Let's check out prometheus and how to run a query
open http://localhost:9090



# Now let's look at Grafana and see how to visualize the CPU metrics into a dashboard
open http://localhost:3000





# Clean up
docker compose down
