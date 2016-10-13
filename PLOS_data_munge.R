library(tidyr)
library(dplyr)

## Expects a CSV conversion of original data. Input appropriate path below.
dat <- read.csv("C:/Users/#######/Downloads/raw_dat.csv", stringsAsFactors=FALSE,check.names=FALSE)

# Original names are messy - some comma seperated, some semi-colon sepearted. (0 male, 1 female etc.)
colnames(dat) = c("id","stim","age_grp","gender","class","Corr_mav","Corr_mavsd","Zygo_mav","Zygo_mavsd", "age")

# Original set has 1 age for the first entry. This fills down the column.
df = dat %>% fill(age)

# Create new columns where the entry is the row difference.
# In terms of a time-series vector this is lag(1).
df = df %>% mutate(delta_corr_mav = Corr_mav-lag(Corr_mav,default=first(Corr_mav)))
df = df %>% mutate(delta_corr_mavsd = Corr_mavsd-lag(Corr_mavsd,default=first(Corr_mavsd)))
df = df %>% mutate(delta_zygo_mav = Zygo_mav-lag(Zygo_mav,default=first(Zygo_mav)))
df = df %>% mutate(delta_zygo_mavsd = Zygo_mavsd-lag(Zygo_mavsd,default=first(Zygo_mavsd)))

# For manual checks of output.
write.csv(df,"C:\\intermed_dat.csv")

# Remove base class.
df = df %>% filter(class!=0)

# Drops unneeded columns, summarizes each column with average function, then orders.
df = df %>% group_by(id,age_grp,gender,class,age) %>% select(id,age_grp,gender,class,age,delta_corr_mav,delta_corr_mavsd,delta_zygo_mav,delta_zygo_mavsd) %>% summarise_each(funs(avg=mean(.))) %>% arrange(id,class)

write.csv(df,"C:\\final_dat.csv")