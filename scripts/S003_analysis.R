

load("crime_flat.Rda")


#

d %>% filter(WARD == 8) %>% group_by(year, OFFENSE) %>% count() %>% ggplot(aes(x=year, y=n, colour=OFFENSE)) + geom_line()



# Split

d %>% filter(WARD == 8, year==2016 | year == 2017) %>% group_by(year, month, OFFENSE) %>% count() %>% ggplot(aes(x=month, y=n, colour=OFFENSE)) + geom_line()


View(d %>% filter(WARD == 8, year==2016 | year == 2017) %>% group_by(year, month, OFFENSE) %>% count())


lastyear <- d %>% filter(WARD == 8, year==2016 | year == 2017) %>% mutate(year_month = paste0(year,"-",month))


l <- lastyear %>% mutate(year_month = paste0(year,"-",month))


l %>% select(year_month, crimetype, n)

ggplot(l, aes(year_month, n, colour=crimetype)) + geom_line()
       