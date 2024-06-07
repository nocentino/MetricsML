## About This Repository

The code in this repository is designed to help you get started on your Machine Learning (ML) journey. Here you will find educational code and resources that demonstrate how to collect, visualize, and analyze SQL Server performance metrics using ML techniques. By exploring the scripts and tools provided in MetricsML, users can gain hands-on experience in applying ML algorithms to identify performance bottlenecks, predict future trends, and enhance database optimization strategies. MetricsML serves as a practical learning platform for anyone interested in integrating ML with SQL Server performance monitoring. The examples in this repository can easily be extended to include workloads outside of SQL Server. 


## Session Abstract

The code in this repository was presented at [PowerShell Summit 2024](https://www.powershellsummit.org/), this is the session abstract. [You can watch the sesion here.](https://www.youtube.com/watch?v=AleqE33JTgU)

In today's data-driven world, the performance and reliability of database and application systems us critical for the success of businesses. This session explores using machine learning to identify performance anomalies in database and application workloads by harnessing performance metrics collected via Prometheus, a widely adopted monitoring and alerting tool.

In this session, you will learn the following:
* Introduction to Prometheus Metrics
* Machine Learning in Fundamentals
* Using Anomaly Detection Models
* Practical Use Cases for Anomaly Detection in system performance monitoring

This session is designed for database administrators, DevOps engineers, data engineers, and anyone interested in ensuring the reliability and optimal performance of their database and application systems. Join us to gain valuable insights into how machine learning, when combined with Prometheus metrics, can change the we monitor and manage workloads, making them more efficient and resilient.


## Getting Started

* Install Docker Desktop: [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/)

* Install Python: [https://www.python.org/downloads/](https://www.python.org/downloads/)

* Pull the repository and run the code each of the following scripts. You will want to run each line of code line by line in your terminal. If you're having trouble watch the video demos in the links below.

  * [`demo-1.sh`](https://github.com/nocentino/MetricsML/blob/main/demo-1.sh) - In this demo, using Docker Compose, you will start up your monitoring stack and an example workload and review each of the components of the monitoring stack, such as Prometheus, Grafana, and Telegraf to learn how performance metrics flow through the monitoring stack. [Link to demo 1 in the video](https://youtu.be/AleqE33JTgU?si=9A-N-8L0L34jXr7p&t=969)
  * [`demo-2.py`](https://github.com/nocentino/MetricsML/blob/main/demo-2.sh) — In this demo, using Python 3, you will get hands-on experience using Prophet at the CLI to make machine-learning predictions based on your example workload. We'll introduce performance metric data access and the data structures used, and then learn how to make predictions on time series data with Prophet. [Link to demo 2 in the video](https://youtu.be/AleqE33JTgU?si=4RL4If1CDtiPi1rz&t=2462)
  * [`demo-3.sh`](https://github.com/nocentino/MetricsML/blob/main/demo-3.sh) - This demo brings everything together, getting data from Prophet into Prometheus using Python. You'll see the example web application for making the metric prediction and then expose those metrics using the Prometheus Client. You will then examine some example dashboards with predicted metrics. [Link to demo 1 in the video](https://youtu.be/AleqE33JTgU?si=Gj04BIFs6rN9vNYs&t=3259)

This is an example appilication intended for instructional purposes only to help you the learner get started using machine learning techniques on data.

## Watch the Conference Session

[Detecting Workload Anomalies with Prometheus and Machine Learning](https://www.youtube.com/watch?v=AleqE33JTgU) from [PowerShell Summit 2024](https://www.powershellsummit.org/)

<p align="center">
  <img href="https://www.youtube.com/watch?v=AleqE33JTgU" src="https://www.nocentino.com/images/MetricsML_PowerShellSummit.png" alt="Detecting Workload Anomalies with Prometheus and Machine Learning by Anthony Nocentino" />
</p>
