#curl -m 3610 -X POST https://add-hc-pricing-data-gwmmhrzkra-uc.a.run.app -H "Authorization: bearer $(gcloud auth print-identity-token)" -H "Content-Type: application/json" -d '{"company": "uhc", "file_url": "https://uhc-tic-mrf.azureedge.net/public-mrf/2022-09-01/2022-09-01_Bind-Benefits--Inc-_TPA_UNITEDHEALTHCARE-CHOICE-PLUS_UCQ_in-network-rates.json.gz", "file_name": "2022-09-01_Bind-Benefits--Inc-_TPA_UNITEDHEALTHCARE-CHOICE-PLUS_UCQ_in-network-rates.json.gz"}'

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