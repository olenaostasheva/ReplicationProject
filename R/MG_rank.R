MG_rank<-function(x){

        #Find industry returns by finding the mean of the returns of all the stocks in each industry
        x<-x %>% group_by(m.ind,date) %>%
                mutate(ind_ret_past = mean(ret.6.0.m, na.rm=TRUE),
                       ind_ret_fut =mean(ret.0.6.m, na.rm=TRUE))

        #select(date, month, m.ind, ind_ret, ret.6.0.m, ret.0.6.m, top.1500)

        ## Create ind.class
        daily <- x %>% group_by(date) %>%
                mutate(ind.class = as.character(ntile(ind_ret_past, n = 3))) %>%
                mutate(ind.class = ifelse(ind.class == "1", "Losers_MG", ind.class)) %>%
                mutate(ind.class = ifelse(ind.class == "3", "Winners_MG", ind.class)) %>%
                mutate(ind.class = factor(ind.class, levels = c("Losers_MG", "2", "Winners_MG"))) %>%
                ungroup()

        #get rid of the 2nd class, we only need Winners and Losers to form our portfolio
        #daily<-filter(daily, ind.class=="Winners_MG" & ind.class=="Losers_MG")

        return(daily)
}
