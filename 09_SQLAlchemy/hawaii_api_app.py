
# Designing a Flask API based on the queries from the completed initial analysis.

################################################################################

# Importing dependecies
import datetime as dt
import numpy as np
import pandas as pd

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import inspect, create_engine, func

from flask import Flask, jsonify, render_template, abort


# Creating connection to hawaii.sqlite database
engine = create_engine("sqlite:///./Resources/hawaii.sqlite")

# Using automap_base to load ORM 
Base = automap_base()

# Reflecting existing table from ORM classes
Base.prepare(engine, reflect = True)
Measurement = Base.classes.measures
Station = Base.classes.stations
print(Base.classes.keys())

# Initiating a session
session = Session(engine)

# Initiating Flask API
app = Flask(__name__)

# List of all returnable API routes.
@app.route('/')
def homepage():
    return(f"<h2>Hawaii Weather Analysis API</h2>"
        f"<h3><i>Available Routes</i></h3>"
        f"<p>(Note: Database available dates range from 2010-01-01 to 2017-08-23 ).</p>"
        
        f"<br><b>/api/v1.0/precipitation</b>  - query dates and temperature from the last year.</br>"

        f"<br><b>/api/v1.0/stations</b>  - return a json list of stations.</br>"

        f"<br><b>/api/v1.0/tobs</b>  - return list of Temperature Observations(tobs) for previous year.</br>"

        f"<br><b>/api/v1.0/yyyy-mm-dd</b>  - return an Average, Max, and Min temperature for given date.</br>"

        f"<br><b>/api/v1.0/yyyy-mm-dd/yyyy-mm-dd</b>  - return an Average, Max, and Min temperature for given period.</br>")



# Displaying the dates and temperature observations from the last year.
@app.route("/api/v1.0/precipitation")
def prcp():
    year_to_date = dt.date.today() - dt.timedelta(days=365)
    prcp_daily = session.query(Measurement.date, func.round(func.sum(Measurement.prcp),2)).\
        filter(Measurement.date >= year_to_date).group_by(Measurement.date).\
        order_by(Measurement.date).all()
    prcp_dict = dict(prcp_daily)
    return jsonify(prcp_dict)

# Displaying a list of weather stations
@app.route("/api/v1.0/stations")
def stations():
    stations_query = session.query(Station.station, Station.name).all()
    return jsonify(stations_query)

# Returning a JSON list of Temperature Observations(tobs) for the previous year
@app.route('/api/v1.0/tobs')
def tobs():
    year_to_date = dt.date.today() - dt.timedelta(days=365)
    tobs_query = session.query(Measurement.date, Measurement.tobs).\
        filter(Measurement.date >= year_to_date).all()
    tobs_dict = dict(tobs_query)
    return jsonify(tobs_dict)


# Catching errors when dates are mistyped. 
@app.errorhandler(404)
def page_not_found(e):
    return("<h1>Page Not Found</h1>"
           "Please enter a date in a range: <b>2010-01-01</b> to <b>2017-08-23</b>"), 404


# Returning a JSON list of the minimum temperature, the average temperature, 
#              and the max temperature for a given start or start-end range.
@app.route('/api/v1.0/<start_date>')
def tobs_start(start_date):

    # Making a query to get measurements
    temp = session.query(
        func.round(func.avg(Measurement.tobs), 2),
        func.min(Measurement.tobs),
        func.max(Measurement.tobs)
    ).filter(Measurement.date >= start_date).first()

    # Converting to dictionary and displaying it in jsonify
    temp_dict_start = {"average temperature": temp[0], "minimum temperature": temp[1], "maximum temperature": temp[2]}
    return jsonify(temp_dict_start)


# Calculating the `TMIN`, `TAVG`, and `TMAX` for dates between the start and end date inclusive, 
#                                      when the start and the end date are given.
@app.route('/api/v1.0/<start_date>/<end_date>')
def tobs_start_end(start_date, end_date):

    # Making a query to get measurements
    temp = session.query(
        func.round(func.avg(Measurement.tobs), 2),
        func.min(Measurement.tobs),
        func.max(Measurement.tobs)
    ).filter(Measurement.date >= start_date, Measurement.date <= end_date).first()

    # Converting to dictionary and displaying it in jsonify
    temp_dict_start_end = {"TAVG": temp[0], "TMIN": temp[1], "TMAX": temp[2]}
    return jsonify(temp_dict_start_end)


if __name__ == '__main__':
    app.run(debug=True)
