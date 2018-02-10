# homecast
**homecast - homemade meteorological forecast**

This repository is currently a private fun-project which aims into building automatic temperature forecasts for a friend of mine with freely available data of a meteorological station, which he is also maintaining.

As basis we use the 'near real-time' observations for temperature of the Hydrographic Service of Carinthia, which are delayed about 15 minutes and available in a 15 minute interval. 


# **How to get run**
- Download this repository
- Copy _crontab.template_ to e.g., _crontab.copy_
- Replace in _crontab_ **PATH2homecast** which describes the path where the local **homecast** directory is located
- Put _crontab_ in the cronjob list, and check if its running with following terminal commands: 
```bash
crontab crontab.copy
crontab -l
```





