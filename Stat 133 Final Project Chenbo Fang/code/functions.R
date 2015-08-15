# ##################################################
# Final Project - Functions
# ##################################################

save_plot = function(file_name){
  plot = recordPlot()
  png(paste0("images/", file_name, ".png"))
  replayPlot(plot)
  dev.off()
  pdf(paste0("images/", file_name, ".pdf"))
  replayPlot(plot)
  dev.off()
}
