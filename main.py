##Let's create a API with Python


import pandas as pd
from flask import Flask, jsonify ##transforms python dictionary in json
app = Flask(__name__)

## built the features
@app.route('/')
def homepage():
  return 'API is available'
  
@app.route('/pullsales')
def pullsales():
  tabela = pd.read_csv('advertising.csv')
  total_vendas = tabela['Vendas'].sum()
## to return as a API we need return a python dicitionary:
## we create a variable called response which is the response we will send to ##the user when they try to access the link @app.route('/pullsales') that will ## be the  dictionaty with the sales total as  below" 
  response = {'total_vendas': total_vendas}
  return jsonify(response)

## run api
## to run this program on the replit server we need to make a small setting:  
app.run(host='0.0.0.0')

##Now, we'll see how to make a request to the end point we just created
## through Python (jutpyter)



