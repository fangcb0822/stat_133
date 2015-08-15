# ##################################################
# Final Project - Analysis
# ##################################################

# packages
library(dplyr)
library(lazyeval)
library(lubridate)
library(stringr)

# import
storms <- read.csv("data/storms.csv")
storms$date <- as.Date(storms$date, "%Y-%m-%d")
tracks <- read.csv("data/tracks.csv")
tracks$date <- as.Date(tracks$date, "%Y-%m-%d")

# create variable year
storms$year <- year(storms$date)
tracks$year <- year(tracks$date)

# create variable month
storms$month <- month(storms$date)
tracks$month <- month(tracks$date)

# restrict to 1980-2010
storms <- subset(storms, year >= 1980 & year <= 2010)
tracks <- subset(tracks, year >= 1980 & year <= 2010)

# functions
source("code/functions.R")

# ==================================================
# Analysis per Year
# ==================================================

# Number of Storms per Year
title <- "Number of Storms per Year"
file_name <- "storms_per_year"
temp_table = data.frame(table(storms[, "year"]), stringsAsFactors = F)
colnames(temp_table) <- c("year", "freq")
save(temp_table, file = paste0("data/", file_name, ".Rda"))
barplot(table(storms[, "year"]), xlab = "Year", ylab = "Number of Storms", main = title)
save_plot(file_name)
# maximum wind speed by storm
by_id <- group_by(tracks, id)
max_wind_id <- summarise(by_id, max_wind = max(wind), year = head(year, 1))
#
# the following codes are to check consistency between results from storms and tracks
# barplot(table(max_wind_id$year))
#
# Number of Storms per Year with Winds >= 35, 64, 96 Knots
for (thres in c(35, 64, 96)) {
  title <- paste0("Number of Storms per Year\nwith Winds >= ", thres, " Knots")
  file_name <- paste("storms_per_year", thres, sep = "_")
  temp_df <- subset(max_wind_id, max_wind >= thres)
  temp_table <- data.frame(table(temp_df[, "year"]), stringsAsFactors = F)
  colnames(temp_table) <- c("year", "freq")
  save(temp_table, file = paste0("data/", file_name, ".Rda"))
  barplot(table(temp_df[, "year"]), xlab = "Year", ylab = "Number of Storms", main = title)
  save_plot(file_name)
}

# ==================================================
# Analysis per Month
# ==================================================

# maximum wind speed by storm and month
by_month_id <- group_by(tracks, id, month)
max_wind_month_id <- summarise(by_month_id, max_wind = max(wind))
# Number of Storms per Month
title <- "Number of Storms per Month"
file_name <- "storms_per_month"
temp_table <- data.frame(table(max_wind_month_id[, "month"]), stringsAsFactors = F)
colnames(temp_table) <- c("month", "freq")
save(temp_table, file = paste0("data/", file_name, ".Rda"))
barplot(table(max_wind_month_id[, "month"]), xlab = "Month", ylab = "Number of Storms", main = title)
save_plot(file_name)
# Number of Storms per Month with Winds >= 35, 64, 96 Knots
for (thres in c(35, 64, 96)) {
  title <- paste0("Number of Storms per Month\nwith Winds >= ", thres, " Knots")
  file_name <- paste0("storms_per_month_", thres)
  temp_df <- subset(max_wind_month_id, max_wind >= thres)
  temp_table <- data.frame(table(temp_df[, "month"]), stringsAsFactors = F)
  colnames(temp_table) = c("month", "freq")
  save(temp_table, file = paste0("data/", file_name, ".Rda"), row.names = F)
  barplot(table(temp_df$month), xlab = "Month", ylab = "Number of Storms", main = title)
  save_plot(file_name)
}

# ==================================================
# Annual Avg Number of Storms
# ==================================================

# maximum wind speed by storm
by_id = group_by(tracks, id)
max_wind_id = summarise(by_id, max_wind = max(wind), year = head(year, 1))
# make function stats()
stats = function(vec, na.rm = T) {
  output = c("Avg" = mean(vec, na.rm = na.rm),
             "Std Dev" = sd(vec, na.rm = na.rm),
             "25th" = quantile(vec, names = FALSE, na.rm = na.rm)[2],
             "50th" = median(vec, na.rm = na.rm),
             "75th" = quantile(vec, names = FALSE, na.rm = na.rm)[4])
  return(output)
}
# make function storms_stats() that takes a threshold wind speed and generate stats of storms with maximum wind >= that threshold
storms_stats = function(thres) {
  temp_df = subset(max_wind_id, max_wind >= thres)
  return(stats(table(temp_df$year)))
}
# make table
file_name = "annual_avg"
temp_table = sapply(c(35, 64, 96), storms_stats)
colnames(temp_table) = c("35 knots", "64 knots", "96 knots")
save(temp_table, file = paste0("data/", file_name, ".Rda"))

# ==================================================
# regression analysis
# ==================================================

# set 0 pressure to NA
tracks$press[tracks$press == 0] = NA
# change wind and press to numeric format
tracks$wind = as.numeric(tracks$wind)
tracks$press = as.numeric(tracks$press)
# make function reg_anal() that takes a function, the name of the function, and file name and generate the wanted regression plot
reg_anal = function(func, func_name, file_name){
  by_id = group_by(tracks, id)
  reg_df = subset(summarise(by_id, press = func(press), wind = func(wind)), press != 0)
  lm = with(reg_df, lm(press ~ wind))
  with(reg_df, plot(press ~ wind,
                    xlab = "Wind (in knots)",
                    ylab = "Pressure",
                    main = paste(func_name, "Pressure vs", func_name, "Wind Speed\nfor Each Storm")))
  abline(lm, col = rgb(1, 0 ,0))
  save_plot(file_name = file_name)
}
# regression analysis 1
func = function(x, na.rm = T) {
  return(mean(x, na.rm = na.rm))
}
func_name = "Mean"
reg_anal(func, func_name, "regression1")
# regression analysis 2
func = function(x, na.rm = T) {
  return(median(x, na.rm = na.rm))
}
func_name = "Median"
reg_anal(func, func_name, "regression2")