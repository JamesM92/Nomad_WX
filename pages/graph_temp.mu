#!/usr/bin/python3
import sqlite3
from time import strftime, localtime

import numpy as np
from uniplot import plot, plot_to_string


from micron_converter import MicronConverter

mc = MicronConverter()


##########
#variables
##########
database = '/var/lib/weewx/weewx.sdb'
data_points = [
  'dateTime',
  'outTemp',
  'outHumidity',
  'heatindex'
  ]


##########
#functions
##########
#def ansi_to_markup(text):
#  ansi_to_markup_dict = [
#    ['\033[30m', '`F000'], #black
#    ['\033[31m', '`Ff00'], #red
#    ['\033[32m', '`F0f0'], #green
#    ['\033[33m', '`Fff0'], #yellow
#    ['\033[34m', '`F00f'], #blue
#    ['\033[35m', '`Ff0f'], #magenta
#    ['\033[36m', '`F0ff'], #cyan
#    ['\033[37m', '`Ffff'], #white
#    ['\033[0m', '`f'] #reset
#  ]
#  for ansi_code, markup in ansi_to_markup_dict:
#    text = text.replace(ansi_code, markup)
#  return text

try:
  conn = sqlite3.connect(database)
  cur = conn.cursor()
  sql_query = f'SELECT {", ".join(data_points)} FROM archive ORDER BY dateTime DESC LIMIT 288'
  cur.execute(sql_query)
  data = cur.fetchall()
  conn.close()
except:
  data = []
  for point in data_points:
    data.appened([None,None])

#print("`aTemp Graphs Page")
#print(data)
time_axis = []
temp_line = []
humi_line = []
heat_line = []
y_lines = []
for row in data:
  time_axis.append(strftime('%Y-%m-%dT%H:%M', localtime(row[0]))) 
  temp_line.append(row[1])
  humi_line.append(row[2])
  heat_line.append(row[3])
  	
y_lines=[heat_line,temp_line,humi_line]	


time_axis = [time_axis, time_axis, time_axis]

graph = plot_to_string(xs=time_axis,ys=y_lines, title="Temp And Humdity", legend_labels=["Heat Index","Temperature","Humidity"], character_set="braille", lines=True, width=100, height=25, color=["yellow","red","blue"])


print(mc.convert(graph))


print("\n")
print("Graph is generated using Uniplot from https://github.com/olavolav/uniplot")
print("The output is then modified to micron using Ansi2MicronMU from https://github.com/JamesM92/Ansi2MicronMU") 
print("\n")
print("`F0FD`[Home`:/page/index.mu`]`f")
