import requests
import json
import os

def get_predictions(request):
    if not request:
        return 0
    city = request.data.decode("utf-8")
    if city == "test":
        ip_tf = os.environ.get("ip_tf")
        r_to_tf = requests.post({0}, ip_tf, {1}, data=json.dumps(city) .format("http://", ":80"))
    else:
        link_api_to_tf = os.environ.get("link_api_to_tf")
        r_to_api = requests.post(link_api_to_tf, data=city)
        print(r_to_api.content)
        data_from_api = r_to_api.content.decode("utf-8")
        ip_tf = os.environ.get("ip_tf")
        r_to_tf = requests.post({0}, ip_tf, {1}, data=data_from_api .format("http://", ":80"))
        print(r_to_tf.content)
    return r_to_tf.content
