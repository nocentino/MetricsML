# Let's dive into the docker compose manifest
code docker-compose.yaml


# Start up our monitoring stack using docker compose
docker compose up --detach


# Check to ensure everything is up and running
docker ps


# Let's first look at the metrics being collected from SQL Server by Telegraf
open http://localhost:9273/metrics 


# Let's check out prometheus and how to run a query
open http://localhost:9090
http://localhost:9090/graph?g0.expr=sqlserver_cpu_sqlserver_process_cpu%5B5m%5D&g0.tab=1&g0.display_mode=lines&g0.show_exemplars=0&g0.range_input=1h
http://localhost:9090/graph?g0.expr=sqlserver_cpu_sqlserver_process_cpu%7Bsql_instance%3D%27aen-sql-22-a%27%7D%5B5m%5D&g0.tab=1&g0.display_mode=lines&g0.show_exemplars=0&g0.range_input=1h
http://localhost:9090/graph?g0.expr=sqlserver_cpu_sqlserver_process_cpu%7Bsql_instance%3D%27aen-sql-22-a%27%7D%5B5m%5D&g0.tab=1&g0.display_mode=lines&g0.show_exemplars=0&g0.range_input=1h
