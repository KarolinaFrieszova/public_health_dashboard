# CodeClan data analysis course week 8 - group project

## Public health dashboard - low birth weight in Scotland

| Authors |
|-|
| Neil Allan |
| Graham Angus |
| Karolina Frieszova |
| Tom Jang |


### Project overview

We were assigned to a group and asked to create an app which gives an overview of Scottish public health over the past 5-10 years.

We were also asked look at a specific health topic topic in this area and present this in a dashboard from three perspectives:

* Temporal: How has this issue changed over time? (Is it getting better or worse?)
* Geographic: How does this issue differ between areas in Scotland? (Where should efforts be focussed?)
* Demographic: Who is most affected by this issue? (Who should be targeted with efforts?)

Additionally, we were told that it would be interesting to see how this issue differs between areas with high and low SIMD (Scottish Index of Multiple Deprivation) ranks.

We chose to look low birth weight data - this is an important health indicator, because low birth weight increases the risk of childhood mortality and of developmental problems for the child, and is associated with poorer health in later life: https://www.nhs.uk/Scorecard/Pages/IndicatorFacts.aspx?MetricId=8308

**Further information on the project can be found in the documentation folder.**



### Folder structure

| Folder | Contents |
|-|-|
| clean_data | The cleaned and joined data produced by the script *data_cleaning.R* |
| dashboard | The ui and server which create the app |
| documentation | Further information on the project, including summary report for presentation |
| raw_data | The source data for the project, taken from https://statistics.gov.scot |
| scripts | Code used to clean and join raw data files, and to select clean data for the app |


### Source data

The project uses data from the https://statistics.gov.scot website downloaded as csv files, along with map data from https://gadm.org/download_country_v3.html

**Please note that the csv and map files are not stored on git hub as some of them are very large**

If you would like to recreate this project, please follow the instructions below on where to find the data, and the location and filenames to use when you save them:


| File | Download From | Save As | Description |
|-|-|-|-|
| Low birth weight data | https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Flow-birthweight | raw_data/birth_weight.csv | Number, and percent, of low birthweight (less than 2500g) babies (single births) |
| Data zone lookup | https://statistics.gov.scot/data/data-zone-lookup | raw_data/datazone_2011_lookup.csv | Geography lookup tables used for aggregation, from 2011 data zones to higher  level geographies |
| Scottish Index of Multiple Deprivation (SIMD) 2020 | https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fscottish-index-of-multiple-deprivation | raw_data/SIMD.csv | Source for the quintile of data zones in Scotland from 1 (most deprived) to 5 (least deprived |
| Map data | https://gadm.org/download_country_v3.html | Select country *UK* and click *Geopackage* This downloads a folder called *gadm36_GBR_gpkg*, which should be saved in raw_data | Map reference data used to show council areas |


