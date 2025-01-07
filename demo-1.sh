# Let's dive into the docker compose manifest
code docker-compose.yaml


# Start up our monitoring stack using docker compose
docker compose up --detach


# Check to ensure everything is up and running
docker ps


# Copy CPU_Sadness.sql into the sql1 container
docker cp ./CPU_Sadness.sql metricsml-sql1-1:/opt/mssql-tools18/bin/CPU_Sadness.sql
docker update metricsml-sql1-1 --cpus 5.00

docker cp ./CPU_Sadness.sql metricsml-sql2-1:/opt/mssql-tools18/bin/CPU_Sadness.sql
docker update metricsml-sql2-1 --cpus 5.00

# let's kick off some load on our sql instance
docker exec -it metricsml-sql1-1 bash
docker exec -it metricsml-sql2-1 bash
/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'S0methingS@Str0ng!' -i /opt/mssql-tools18/bin/CPU_Sadness.sql -No &
exit
docker stats


# Let's first look at the metrics being collected from SQL Server by Telegraf
open http://localhost:9273/metrics


# Quick review of the telegraf configuration for the SQL Server plugin
code ./telegraf/telegraf.conf


# Let's look at the prometheus configuration file
code ./prometheus/prometheus.yml


# Let's check out prometheus and how to run a query
open http://localhost:9090


# Let's look at the grafana configuration file
code ./grafana/datasources/datasource.yaml


# Now let's look at Grafana and see how to visualize the CPU metrics into a dashboard
open http://localhost:3000


# Things to check out, 
# 1. Explore the data source
# 2. Explore the dashboard and its variables
# 3. Explore the query for CPU usage
