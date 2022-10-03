#what about this?
from flask import Flask, request
import os
app = Flask(__name__)

@app.route('/', methods = ['POST'])
def main():
    message = request.get_json(force=True)
    company = message['company']
    file_url = message['file_url']
    file_name = message['file_name']
    os.system(f" curl '{file_url}' | gsutil cp - gs://data-platform-data/{company}/{file_name}")
    return "SUCCESS"
    #wget 
    

if __name__ == "__main__":
    port = int(os.environ.get('PORT', 8000))
    app.run(debug=True, host='0.0.0.0', port=port)