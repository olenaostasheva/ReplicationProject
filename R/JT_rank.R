JT_rank <- function(x){

        ## Now get rid of the rows with NA
        x<- x %>% group_by(date) %>%
                mutate(ret.class = as.character(ntile(ret.6.0.m, n = 3))) %>%
                mutate(ret.class = ifelse(ret.class == "1", "Losers_JT", ret.class)) %>%
                mutate(ret.class = ifelse(ret.class == "3", "Winners_JT", ret.class)) %>%
                mutate(ret.class = factor(ret.class, levels = c("Losers_JT", "2", "Winners_JT"))) %>%
                ungroup()

        #Get rid of the 2nd class, do not need it.
        #x<-filter(x,ret.class=="Winners_JT" & ret.class=="Losers_JT")

        return(x)
}
