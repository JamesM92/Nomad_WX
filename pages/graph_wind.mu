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
  'windSpeed',
  'rain'
  ]










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
wind_line = []
rain_line = []
y_lines = []
for row in data:
  time_axis.append(strftime('%Y-%m-%dT%H:%M', localtime(row[0]))) 
  wind_line.append(row[1])
  rain_line.append(row[2])
  #y_lines.append([row[1],row[2]])	
y_lines=[wind_line,rain_line,]	
#y_lines.append(temp_line)
#y_lines.append(humi_line)
time_axis = [time_axis, time_axis]

graph = plot_to_string(xs=time_axis,ys=y_lines, title="Wind And Rain", legend_labels=["Wind Speed","Rain(in.)"], character_set="braille", color=True, width=100, height=20)
print(mc.convert(graph))

print("\n")
print("Graph is generated using Uniplot from https://github.com/olavolav/uniplot")
print("The output is then modified to micron using Ansi2MicronMU from https://github.com/JamesM92/Ansi2MicronMU") 
print("\n")


print("`F0FD`[Home`:/page/index.mu`]`f")
