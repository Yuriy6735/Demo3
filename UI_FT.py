#!/usr/bin/env python
# coding: utf-8

# # Welcome to Jupyter!

# In[24]:


import requests
import json
import ipywidgets as widgets
import matplotlib.pyplot as plt
import ipywidgets as widgets

get_ipython().run_line_magic('matplotlib', 'inline')

button = widgets.Button(description="Show prediction")
display(button)
out = widgets.Output()
city = widgets.Dropdown(
    options=["Kyiv", "Odessa", "Lviv", "Kharkiv", "Dnipro", "Ivano-Frankivsk", "Chernivtsi",
             "Vinnytsia", "Kriviy Rih", "Uzhhorod"],
    value="Kyiv",
    description='Cities:',
    disabled=False,
)

display(city)


def click_button(c):
    arg = city.value

    r = requests.post('https://us-central1-careful-time-232710.cloudfunctions.net/get-predictions', data=arg)
    pred = json.loads(r.content.decode("utf-8"))
    print("Prediction mean temperature for tomorrow in {0} {1} Celsius degree".format(arg, pred[arg]))


button.on_click(click_button)

button = widgets.Button(description="Test predictions")
display(button)
out = widgets.Output()


def click_button(d):
    arg = "test"

    r = requests.post('https://us-central1-careful-time-232710.cloudfunctions.net/get-predictions', data=arg)
    demo_data = json.loads(r.content.decode("utf-8"))

    warmup_steps = 20

    # Get the output-signal predicted by the model.
    signal_pred = demo_data["pred_data"][:100]

    # Get the true output-signal from the data-set.
    signal_true = demo_data["test_data"][:100]

    # Make the plotting-canvas bigger.
    plt.figure(figsize=(15, 5))

    # Plot and compare the two signals.
    plt.plot(signal_true, label='true')
    plt.plot(signal_pred, label='pred')

    # Plot grey box for warmup-period.
    p = plt.axvspan(0, warmup_steps, facecolor='black', alpha=0.15)

    # Plot labels etc.
    plt.ylabel("temp")
    plt.legend()
    plt.show()


button.on_click(click_button)

#

#
