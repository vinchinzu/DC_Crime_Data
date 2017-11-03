#install.packages("leaflet")
library(leaflet)
hom <- d %>% filter(OFFENSE == "ASSAULT W/DANGEROUS WEAPON", year == 2017, month == )
m <- leaflet(data = hom) %>% addTiles() %>%
  addMarkers(~XBLOCK, ~YBLOCK, popup = ~as.character(hom$REPORT_DAT))

m  
qlibrary(htmlwidgets)
saveWidget(m, file="homoicide_plot.html")

###hard to loadd
###Save and attache



