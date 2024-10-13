library(httr)
library(jsonlite)
library(dplyr)
library(lubridate)



##-------Bendra Info--------

response <- GET("https://www.vrk.lt/statiniai/puslapiai/rinkimai/1544/1/2150/rezultatai/rezultataiVienmVrt.json")
vnm0 <- content(response, "text", encoding = "UTF-8")
vnm <- vnm0 %>% fromJSON()


tdu <- as.data.frame(vnm$data$bendraInfo)
tmst <- ymd_hms(vnm$header$date, tz = "Europe/Vilnius")

write.csv(tdu,paste0("data/20241013/raw_data/vienmvrt_",tmst,".csv"),  row.names=FALSE)

tdu1 <- tdu %>% mutate(timestamp = tmst)

#fda <- read.csv("data/20241013/bendrainfo.csv")

#fda1 <- bind_rows(fda, tdu1) %>% unique

#fda1 %>% write.csv("data/20241013/bendrainfo.csv", row.names = FALSE)


##----Balsu eiga

response <- GET("https://www.vrk.lt/statiniai/puslapiai/rinkimai/1544/1/2150/rezultatai/rezultataiDaugmVrt.json")
oo0 <- content(response, "text", encoding = "UTF-8")
oo <- oo0 %>% fromJSON()

tmst1 <- ymd_hms(oo$header$date, tz = "Europe/Vilnius")

write.csv(oo$data$balsai,paste0("data/20241013/raw_data/daugmvrt_",tmst1,".csv"),  row.names=FALSE)

dgm <- oo$data$balsai
dgm1 <- dgm %>% mutate(partija = gsub("^[0-9]*[.] ","", partija)) %>% na.omit %>%
    mutate(timestamp = tmst1, apylinkes = tdu$apylinkiu_sk_pateike, lt_proc_rinkeju = tdu$pateike_rink_sudaro_proc)

dgm2 <- dgm1 %>% mutate(saraso_numeris = as.integer(saraso_numeris),
                        rorg_id = as.integer(rorg_id),
                        balsadezese = as.integer(rorg_id),
                        pastu = as.integer(pastu),
                        is_viso = as.integer(is_viso),
                        mandatu_skaicius = as.integer(mandatu_skaicius),
                        proc_nuo_gal_biul = as.numeric(proc_nuo_gal_biul),
                        proc_nuo_dal_rinkeju = as.numeric(proc_nuo_dal_rinkeju),
                        proc_nuo_rinkeju = as.numeric(proc_nuo_rinkeju),
                        timestamp = as.character(timestamp),
                        apylinkes = as.integer(apylinkes),
                        lt_proc_rinkeju = as.numeric(lt_proc_rinkeju))

fdgm <- read.csv("data/20241013/daugmvrt.csv")

fdgm1 <- rbind(fdgm, dgm2) %>% unique

fdgm1 %>% write.csv("data/20241013/daugmvrt.csv", row.names = FALSE)

