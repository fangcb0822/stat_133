Description of the Project
---

In this project, we study the attributes of storms in East Pacific and North Atlantic basins.

We use the database [International Best Track Archive for Climate Stewardship (IBTrACS)](https://www.ncdc.noaa.gov/ibtracs/index.php?name=wmo-data) as our source of data.

Author
---

This project is independently completed by Chenbo Fang (SID 22885144).

Organization of Directories and Files
---

- The directory [code](../code) contains the R scripts that generate clearned data, analyses, and images as well as the file [functions.R](../code/functions.R).
- The directory [rawdata](../rawdata) contains the original data files downloaded directly from the database [IBTrACS](https://www.ncdc.noaa.gov/ibtracs/index.php?name=wmo-data).
- The directory [data](../data) contains the cleaned data (in csv) as well as the data to generate certain tables in analysis (in Rda).
- The directory [images](../images) contains all the plots generated for analysis purpose.
- The directory [report](../images) contains the related files (Rmd and pdf) for the final report.
- The directory [resources](../resources) contains any downloaded resource files related to this project (in this case none).

Regarding Bonus Points
---

- In addition to Dropbox I also set up the project in [my GitHub repository](https://github.com/fangcb0822/stat_133).
- I used 3 loops in total.
- I used the function `group_by` from package __"dplyr"__ in [data_analysis.R](../code/data_analysis.R).
- I posted one of the project images on [my LinkedIn](https://www.linkedin.com/in/chuckfang).