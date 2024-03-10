import requests
import time
import sys
import pandas as pd
from prophet import Prophet


# Prometheus api endpoint for query 
URL = "http://localhost:9090/api/v1/query"

# CPU Query
PROMQL1 = {'query':'sqlserver_cpu_sqlserver_process_cpu[15m]'}

#Get the response from the prometheus api
r1 = requests.get(url = URL, params = PROMQL1)


# Convert the response to json and return just the time stamp and the metric value
r1_json = r1.json()


#write a dataframe that converts the json to a dataframe ready for prophet with timestamp as the first columm and the metric value as the second column
df = pd.DataFrame(r1_json['data']['result'][0]['values'], columns=['ds', 'y'])


#write a block that uses prophet to forecast the next 7 days of metrics from the dataframe
df['ds'] = pd.to_datetime(df['ds'], unit='s')
m = Prophet()
m.fit(df)
future = m.make_future_dataframe(periods=7)  
forecast = m.predict(future)
forecast[['ds', 'yhat', 'yhat_lower', 'yhat_upper']].tail()



#https://facebook.github.io/prophet/docs/quick_start.html#python-api
import pandas as pd
from prophet import Prophet

df = pd.read_csv('https://raw.githubusercontent.com/facebook/prophet/main/examples/example_wp_log_peyton_manning.csv')
df.head()

m = Prophet()
m.fit(df)

future = m.make_future_dataframe(periods=365)
future.tail()

forecast = m.predict(future)
forecast[['ds', 'yhat', 'yhat_lower', 'yhat_upper']].tail()