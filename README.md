# ps239T-final-project
### Date: 4/25/2018

*Description*:These scripts are part of a larger project focusing on examining political elites in Colombia on Twitter. The code found in this file can be used to gather locations of a Twitter user's 'friends' (i.e. who they themselves follow) and map all of the 'friends' that have put some sort of location into their profile info. 

**IDEs used:** <br />
  Python: Jupyter Notebook, Python 3.6.1 <br />
  R: RStudio, R Version 3.4.3 Kite-Eating-Tree <br />
**Packages used are:** <br />
  Python: tweepy, json, csv, pandas, datetime, time <br />
  R: dplyr, ggmap, ggplot2, maps, stringr


## Running the scripts
*Order of running files is numerical.* <br />
  1_twitter_api.ipynb <br />
  2_data_cleaning.R <br />
  3_visualization.R <br />
  4_saving_results.R <br />

### 1_twitter_api
Go to __developer.twitter.com__ to register an app and receive the 4 needed keys to access the API. <br />
Create an empty (truly empty!) csv file in sublime or nano to work with for this script. <br />
Run script! Refer to inline comments for explanations and logic. <br />
Expected processing time is around **3 hours**

### 2_data_cleaning
Read in the dataset produced from the previous script. <br />
Clean and manipulate the data (see inline comments for explanations.) <br />
Begin 3rd script when the main dictionary and all locations lists have been created.
    Dictionary uses Google Maps geocoding API and requires another app and keys. <br />
    *Note:* When calling the geocode api, the rate limit is 2500 requests per day. Make sure you're calling these data right the first time
    Expected processing time is around **30 minutes**

### 3_visualization
Using ggplot2, ggmap, and maps, create map charts (currently: 10) <br />
Expected processing time is around **10 minutes**

### 4_saving_results
In the loop, ggsave each chart as pdf. (Best to import in laTEX) <br />
Expected processing time is around **10 minutes**



