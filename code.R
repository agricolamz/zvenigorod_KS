setwd("/home/agricolamz/work/articles/2023_DiaL2/zvenigorod_S")
library(tidyverse)
df <- readxl::read_xlsx("KS_zvenigorod.xlsx")

df |> 
  mutate(audio = str_remove(source, ".eaf"),
         audio = str_c(audio, "-", round(time_start*1000)),
         audio = str_c(audio, "-", round(time_end*1000)),
         audio = str_c("http://lingconlab.ru/zvenigorod/OUT/", audio, ".wav")) |> 
  select(sentence, audio, token) |> 
  distinct() |> 
  mutate(id = 1:n()) |> 
  write_csv("result.csv")

df <- read_csv("result.csv")

setwd("audio/")
map(seq_along(df$audio), function(i){
  curl::curl_download(df$audio[i], str_c(df$id[i], ".wav"))  
})

