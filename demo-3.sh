# Let's check out the whole python application that we have created in the previous demo
code app.py


# The app is up and running inside the container when we started docker compose
docker ps


# Let's check the logs of the container
docker logs -f metricsml-metricsml-1


# Let's check the application using curl, the base URL prints the application name and version
curl http://localhost:8000


# Let's check the /metrics endpoint, which is the prometheus metrics
curl http://localhost:8000/metrics


# Let's check the logs of the container again 
docker logs -f metricsml-metricsml-1


# Now let's measure how long it takes to scrape the /metrics endpoint
time curl http://localhost:8000/metrics


# Remember the scrape jobs that we have defined in the prometheus configuration file...let's review
code ./prometheus/prometheus.yml



# Open the prometheus dashboard, and look for predicted metrics
open http://localhost:9090
