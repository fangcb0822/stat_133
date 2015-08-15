# ##################################################
# Final Project - Visualization
# ##################################################

# notes
# num and basin are screwed up in the database

# packages
library(ggplot2)
library(maps)
library(stringr)

# functions
source("code/functions.R")

# ==================================================
# data processing
# ==================================================

# import and combine
storms2_EP <- read.csv("rawdata/Basin.EP.ibtracs_wmo.v03r06.csv", skip = 2, header = T, stringsAsFactors = F)
storms2_NA <- read.csv("rawdata/Basin.NA.ibtracs_wmo.v03r06.csv", skip = 2, header = T, stringsAsFactors = F)
storms2 <- subset(rbind(storms2_EP, storms2_NA), Year >= 1980 & Year <= 2010)
colnames(storms2) = c("serial_num",
                  "year",
                  "num",
                  "basin",
                  "sub_basin",
                  "name",
                  "time",
                  "nature",
                  "lat",
                  "long",
                  "wind",
                  "press",
                  "center",
                  "wind_pct",
                  "press_pct",
                  "track_type")
# generate variables of interest
storms2$wind_level = cut(storms2$wind, breaks = seq(from = 0, to = 200, by = 50))
storms2$month = factor(month.name[as.numeric(substr(storms2$time, 6, 7))],
                       levels = month.name)
storms2$decade = paste0(substr(storms2$time, 1, 3), "0s")
# sort by serial number and time
storms2 = with(storms2, storms2[order(serial_num, time), ])

# ==================================================
# data visualization
# ==================================================

# specify limits for longitude and latitude
long_lim = c(-130, -30)
lat_lim = c(5, 55)
# generate map_area
map_area = subset(map_data("world"),
                  long > long_lim[1] & long < long_lim[2] & lat > lat_lim[1] & lat < lat_lim[2])

# color parameters
bg = rgb(0, 0, 0)
# baseline ggplot
mp = ggplot(data = storms2, aes(x = long, y = lat, group = serial_num)) +
  geom_polygon(data = map_area, aes(x = long, y = lat, group = group)) +
  geom_path(aes(col = wind)) +
  xlim(long_lim) + ylim(lat_lim) +
  theme(panel.background = element_rect(fill = bg),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  xlab("Longitutde") + ylab("Latitude")
# Storm Trajectories 1980-2010
title = "Storm Trajectories 1980-2010"
mp + ggtitle(title)
save_plot(file_name = "trajectory")
# Storm Trajectories by Month (1980-2010)
title = "Storm Trajectories by Month (1980-2010)"
mp + ggtitle(title) + facet_wrap(~ month)
save_plot(file_name = "trajectory_per_month")
# Storm Trajectories by Year in Decade 1980s, 1990s, and 2000s
for (target_decade in c("1980s", "1990s", "2000s")) {
  title = paste("Storm Trajectories by Year in Decade", target_decade)
  temp_df = subset(storms2, decade == target_decade)
  plot = ggplot(data = temp_df, aes(x = long, y = lat, group = serial_num)) +
    geom_polygon(data = map_area, aes(x = long, y = lat, group = group)) +
    geom_path(aes(col = wind)) +
    xlim(long_lim) + ylim(lat_lim) +
    theme(panel.background = element_rect(fill = bg),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    xlab("Longitutde") + ylab("Latitude") +
    ggtitle(title) +
    facet_wrap(~ year)
  print(plot)
  save_plot(paste("trajectory", target_decade, sep = "_"))
}
