# homecast
**homecast - homemade meteorological forecast**

This repository is currently a private fun-project which aims into building automatic temperature forecasts for a friend of mine with freely available data of a meteorological station, which he is also maintaining.

As basis we will use the 'near real-time' observations for temperature of the Hydrographic Service of Carinthia, which are delayed about 15 minutes and available in a 15 minute interval. 

Currently, only the automatic visualization for observational data is running:

- gets the data  (_extracting.R_)
- merges all data and create R timeseries (zoo-object) (_merging.R_)
- plots the temperature data (_plot.R_)


# **How to get the observations automatically**
- Download this repository
- Copy _crontab.template_ to e.g., _crontab.copy_
- Replace in _crontab.copy_ '**PATH2homecast**' which describes the path where the local **homecast** directory is located
- Put _crontab.copy_ in the cronjob list, and check if its running with following terminal commands: 
```bash
crontab crontab.copy
crontab -l
```


# **Future steps**
- Make some nice visualization
- Getting some numerical weather data (NWP), such as GFS or even better GEFS
- Apply some statistical post-processing method to observational/NWP data