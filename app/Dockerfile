#alpine image with python3, pip3, and gcloud sdk
FROM google/cloud-sdk:alpine

#install python3 and pip3
RUN apk add --no-cache python3 && ln -sf python3 /usr/bin/python
RUN apk add --no-cache py3-pip && ln -sf pip3 /usr/bin/pip

#install requirements
COPY requirements.txt .
RUN pip3 install -r requirements.txt

#copy files
COPY . .

#run flask app
CMD ["python3", "app.py"]
