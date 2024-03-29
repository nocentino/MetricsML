
# Create a web server and call the get_predictions function on each http request
class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        
        predicted_metrics = get_predictions()
        
        # if this is the first page load create the gauge metrics
        if not hasattr(MyServer, 'gauge'):
            MyServer.gauge = {}
            for metricname, metricvalue in predicted_metrics.items():
                MyServer.gauge[metricname] = Gauge(metricname, 'Description of gauge')
                
        # on subsequent page loads update the gauge metrics
        for metricname, metricvalue in predicted_metrics.items():
            MyServer.gauge[metricname].set(metricvalue) 

# Create a prometheus server to expose the metrics to prometheus
if __name__ == '__main__':
    start_http_server(8000) 
    print('running server...')
    server_address = ('localhost', 8080)
    httpd = HTTPServer(server_address, MyServer)
    print('running server...')
    httpd.serve_forever()
