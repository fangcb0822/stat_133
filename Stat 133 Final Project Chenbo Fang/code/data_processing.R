# ##################################################
# Final Project - Data Processing
# ##################################################

# packages
library(lubridate)
library(stringr)

# import
raw <- readLines("rawdata/Basin.NA.ibtracs_hurdat.v03r06.hdat")

# ==================================================
# storms.csv
# ==================================================

headers <- grep("SNBR=", raw, value = T)
id <- 1:length(headers)
date <- as.Date(substr(headers, 7, 16), "%m/%d/%Y")
days <- as.numeric(substr(headers, 20, 21))
name <- str_extract(str_sub(str_replace(headers, "XING=.*", ""), -12, -1), "^[[:alpha:]]+")
storms <- data.frame(id = id,
                    date = date,
                    days = days,
                    name = name,
                    stringsAsFactors = F)
write.csv(storms, file = "data/storms.csv", row.names = F)

# ==================================================
# tracks.csv
# ==================================================

# daily data
daily_data <- raw[!grepl("SNBR=|SRC=", raw)]
daily_data_list <- strsplit(daily_data, "[\\*SEWL]", perl = T)
# id
id <- with(storms, rep(id, days))
# date (assume year does not change for each storm)
year <- year(with(storms, rep(date, days)))
date <- as.Date(paste0(year, "/", str_sub(sapply(daily_data_list, "[[", 1), -5, -1)), "%Y/%m/%d")
# reshape
temp_df <- data.frame(id = id,
                     date = date,
                     stage1 = str_sub(daily_data, 12, 12),
                     stage2 = str_sub(daily_data, 29, 29),
                     stage3 = str_sub(daily_data, 46, 46),
                     stage4 = str_sub(daily_data, 63, 63),
                     info_00h = sapply(daily_data_list, "[[", 2),
                     info_06h = sapply(daily_data_list, "[[", 3),
                     info_12h = sapply(daily_data_list, "[[", 4),
                     info_18h = sapply(daily_data_list, "[[", 5),
                     index = 1:length(id),
                     stringsAsFactors = F)
tracks <- reshape(temp_df,
                 idvar = "index",
                 varying = list(c(3:6), c(7:10)),
                 v.names = c("stage", "info"),
                 timevar = "period",
                 times = c("00h", "06h", "12h", "18h"),
                 direction = "long")
# sort by id, date, and period
tracks <- with(tracks, tracks[order(id, date, period), ])
# stage
tracks$stage[tracks$stage == "*"] <- "tropical cyclone"
tracks$stage[tracks$stage == "S"] <- "subtropical"
tracks$stage[tracks$stage == "E"] <- "extratropical"
tracks$stage[tracks$stage == "W"] <- "wave"
tracks$stage[tracks$stage == "L"] <- "remanent low"
# lat, long, wind, and press
tracks$lat <- as.numeric(str_sub(tracks$info, 1, 3))/10
tracks$long <- as.numeric(str_sub(tracks$info, 4, 7))/10
tracks$long[tracks$long > 180] <- tracks$long[tracks$long > 180] - 360
tracks$wind <- as.numeric(str_sub(tracks$info, 9, 11))
tracks$press <- as.numeric(str_sub(tracks$info, -4, -1))
# remove those observations where lat, long, wind and press are all zeros
tracks <- subset(tracks, lat != 0 | long != 0 | wind != 0 | press != 0)
# delete unwanted variables
row.names(tracks) <- NULL
tracks$index <- NULL
tracks$info <- NULL
# save
write.csv(tracks, file = "data/tracks.csv", row.names = F)
