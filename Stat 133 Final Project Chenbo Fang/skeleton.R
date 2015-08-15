# ##################################################
# Final Project - Skeleton
# ##################################################

# ==================================================
# create README.md
# ==================================================

if (!file.exists("README.md")) file.create("README.md", showWarnings = F)

# ==================================================
# create directories
# ==================================================

dir.create("rawdata", showWarnings = F)
dir.create("data", showWarnings = F)
dir.create("code", showWarnings = F)
dir.create("images", showWarnings = F)
dir.create("report", showWarnings = F)
dir.create("resources", showWarnings = F)

# ==================================================
# download raw data files
# ==================================================

# Basin.NA.ibtracs_hurdat.v03r06.hdat
download.file(url = "ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r06/wmo/hurdat_format/basin/Basin.NA.ibtracs_hurdat.v03r06.hdat",
              destfile = "rawdata/Basin.NA.ibtracs_hurdat.v03r06.hdat")
# Basin.EP.ibtracs_wmo.v03r06.csv
download.file(url = "ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r06/wmo/csv/basin/Basin.EP.ibtracs_wmo.v03r06.csv",
              destfile = "rawdata/Basin.EP.ibtracs_wmo.v03r06.csv")
# Basin.NA.ibtracs_wmo.v03r06.csv
download.file(url = "ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r06/wmo/csv/basin/Basin.NA.ibtracs_wmo.v03r06.csv",
              destfile = "rawdata/Basin.NA.ibtracs_wmo.v03r06.csv")
