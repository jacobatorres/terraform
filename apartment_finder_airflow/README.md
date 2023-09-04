README

- this app uses Airflow to scrape data, then provides this data in a website to show the best areas in Los Angeles based on Parking Data and Crime
 
- scrape Parking Data -> Clean it up -> get Lat Long of data (if not available) -> save data in DB
- scrape Crime Data -> Clean it up -> get Lat Long of data (if not available) -> save data in DB
- scrape median income Data -> Clean it up -> 
- merge data into a filterable map. Via Hexbin or Leaflet

- airflow 


this quarter
lets do it by hand


quick and dirty
- get parking data -> clean it up -> save it in a postgres SQL in DB -> 

- save everything to a table, be able to determine the top cities based on parking, crime

- go to a website, opionate


VPC
ec2 instance (has airflow)


good: no terraform
great: with terraform


read up on airflow
learn how to do airflow in terraform (mwaa)
add basic script in mwaa
kill using terraform ! save money
think of how to do the scraping via airflow
create terraform for postgres, other stuff for the project




