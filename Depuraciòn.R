library(readr)

df1 <- read_csv("ddf--datapoints--age_at_1st_marriage_women--by--geo--time.csv")

df2 <- read_csv("ddf--datapoints--alternative_poverty_percent_below_nationally_defined_poverty--by--geo--time.csv")

df3 <- read_csv("ddf--datapoints--females_aged_15plus_labour_force_participation_rate_percent--by--geo--time.csv")

df4 <- read_csv("ddf--datapoints--literacy_rate_adult--by--geo--gender--time.csv")

df5 <- read_csv("ddf--datapoints--mean_years_in_school_men_15_to_24_years--by--geo--time.csv")

df6 <- read_csv("ddf--datapoints--mean_years_in_school_women_15_to_24_years--by--geo--time.csv")

dfcat <- read_csv("ddf--entities--geo--country.csv")


library(dplyr)
filterfun <- function(x){
  x %>% filter(time >= 1972 & time <= 2019)
}

df1 <- filterfun(df1)
df2 <-filterfun(df2)
df3 <-filterfun(df3)
df4 <-filterfun(df4)
df5 <-filterfun(df5)
df6 <-filterfun(df6)

dfregions <- data.frame(geo = dfcat$country,region = dfcat$world_4region)
dfreligions <- data.frame(geo = dfcat$country,religion = dfcat$main_religion_2008)
dfcoutnry <- data.frame(geo = dfcat$country,country = dfcat$name)
dfiso <-data.frame(geo = dfcat$country,iso = dfcat$iso3166_1_numeric)

df1paste <-  paste(df1$geo,df1$time)
df2paste <-  paste(df2$geo,df2$time)
df3paste <-  paste(df3$geo,df3$time)
df4paste <-  paste(df4$geo,df4$time)
df5paste <-  paste(df5$geo,df5$time)
df6paste <-  paste(df6$geo,df6$time)


dff1 <- data.frame('id'=df1paste,'1stmarr'=df1$age_at_1st_marriage_women)
dff2 <- data.frame('id'=df2paste,'Poverty'=df2$alternative_poverty_percent_below_nationally_defined_poverty)
dff3 <- data.frame('id'=df3paste,'FemLabour'=df3$females_aged_15plus_labour_force_participation_rate_percent)
dff4 <- data.frame('id'=df4paste,'gender'=df4$gender,'Literacy'=df4$literacy_rate_adult)
dff5 <- data.frame('id'=df5paste,'MenSchoolYr'=df5$mean_years_in_school_men_15_to_24_years)
dff6 <- data.frame('id'=df6paste,'FemSchoolYr'=df6$mean_years_in_school_women_15_to_24_years)


mergefun <- function(x,y){
  merge(x, y, by = "id", all = T)
}

dff12 <- mergefun(dff1,dff2)
dff13 <- mergefun(dff12,dff3)
dff14 <- mergefun(dff13,dff4)
dff15 <- mergefun(dff14,dff5)
dffinal <- mergefun(dff15,dff6)

library(tidyr)

dffinal <- dffinal %>% separate(id, c('geo', 'time'))
dffinal <- merge(dffinal, dfregions, by = "geo", all = T)
dffinal <- merge(dffinal, dfreligions, by = "geo", all = T)
dffinal <- merge(dffinal, dfreligions, by = "geo", all = T)
dffinal <- merge(dffinal, dfcoutnry, by = "geo", all = T)
dffinal <- merge(dffinal, dfiso, by = "geo", all = T)




dffinal <- dffinal %>% fill(FemSchoolYr)
dffinal <- dffinal %>% fill(X1stmarr)
dffinal <- dffinal %>% fill(FemLabour)
dffinal <- dffinal %>% fill(Poverty)

library(tidyverse)

df_filtered <- dffinal %>% drop_na(iso)

write_csv(df_filtered,"Datos/Datos_Depurados.csv")

