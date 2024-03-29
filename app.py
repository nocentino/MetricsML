import requests, platform
import time, sys, os, re
import pandas
from prophet import Prophet
from prometheus_client import start_http_server, Gauge, make_wsgi_app
from wsgiref.simple_server import make_server

# Class to hold the sql instance name and the dictionary of metrics
class sql_instance:
    def __init__(self, sql_instance_name):
        self.sql_instance_name = sql_instance_name
        self.metrics = {}
        

def get_predictions():
    # Prometheus api endpoint for query
    URL = os.getenv('PROMETHEUS') 


    # CPU Query
    PROMQL1 = {'query':'sqlserver_cpu_sqlserver_process_cpu[1d]'}


    # Get the response from the prometheus API
    r1 = requests.get(url = URL, params = PROMQL1)


    # Convert the response to json and return just the time stamp and the metric value
    r1_json = r1.json()


    # A dataframe that converts the json to a dataframe ready for prophet with timestamp as the first columm and the metric value as the second column for each result
    df = pandas.DataFrame()  

    # for each result in the json response, create a dataframe with the timestamp and the metric value
    for result in r1_json['data']['result']:
        df = pandas.concat([df, pandas.DataFrame(result['values'], columns=['ds', 'y'])])
        

    # Use prophet to predict a value 5 minutes in the future based off of the data in the data frame
    df['ds'] = pandas.to_datetime(df['ds'], unit='s')
    m = Prophet()
    m.fit(df)
    future = m.make_future_dataframe(periods=300, freq='s')      #Automatically fits to sampling interval in the data set, here its 30 seconds
    forecast = m.predict(future)                                 #Will predict each interval up until the number of periods

    # Extract the metric name, hostname from the json response. Build the string that is the new metric name.
    my_predicted_sql_instance = r1_json['data']['result'][0]['metric'].get('sql_instance')
    predicted_metric_name = r1_json['data']['result'][0]['metric'].get('__name__')
    predicted_metric_name_yhat = predicted_metric_name + '_yhat'
    predicted_metric_name_yhat_lower = predicted_metric_name + '_yhat_lower'
    predicted_metric_name_yhat_upper = predicted_metric_name + '_yhat_upper'


    # Load up the predicted value and the lower and upper bounds, only non-negative values are allowed
    predicted_metric_value_yhat = forecast[['yhat']].tail(1).values[0][0]
    predicted_metric_value_lower = max ( 0, forecast[['yhat_lower']].tail(1).values[0][0] )
    predicted_metric_value_upper = max ( 0, forecast[['yhat_upper']].tail(1).values[0][0] )


    # Create a dictonary for the predicted metric values and the lower and upper bounds
    predicted_metrics = {
        predicted_metric_name_yhat: predicted_metric_value_yhat, 
        predicted_metric_name_yhat_lower: predicted_metric_value_lower, 
        predicted_metric_name_yhat_upper: predicted_metric_value_upper}

    # instantiate the sql_instance class
    my_sql_instance = sql_instance(my_predicted_sql_instance)
    my_sql_instance.metrics = predicted_metrics
    
    print("Get metrics...\nPrometheus Results Evaluated: " + str(df.y.count()) )

    return my_sql_instance

def get_metrics():
    predicted_metrics = get_predictions()
    
    # if this is the first page load create the gauge metrics and set the labels
    if not hasattr(get_metrics, 'gauge'):
        get_metrics.gauge = {}
        for metricname, metricvalue in predicted_metrics.metrics.items():
            get_metrics.gauge[metricname] = Gauge(metricname, metricname, ['sql_instance'])
            
            
    # on subsequent page loads update the gauge metrics
    for metricname, metricvalue in predicted_metrics.metrics.items():
            get_metrics.gauge[metricname].labels(sql_instance=predicted_metrics.sql_instance_name).set(metricvalue)


def my_app(environ, start_fn):
    if environ['PATH_INFO'] == '/metrics':
        get_metrics()
        return metrics_app(environ, start_fn)
    start_fn('200 OK', [])
    return [b'MetricsML Server v0.01\n']

if __name__ == '__main__':
    metrics_app = make_wsgi_app()
    httpd = make_server('', 8000, my_app)
    httpd.serve_forever()