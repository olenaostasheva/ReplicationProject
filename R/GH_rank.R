GH_rank<- function(data) {

        data %>% group_by(date) %>%
                mutate(wh.52.class = as.character(ntile(wh_52_ratio, n = 3))) %>%
                mutate(wh.52.class= ifelse(wh.52.class == "1", "Losers_GH", wh.52.class)) %>%
                mutate(wh.52.class = ifelse(wh.52.class == "3", "Winners_GH", wh.52.class)) %>%
                mutate(wh.52.class = factor(wh.52.class, levels = c("Losers_GH", "2", "Winners_GH"))) %>%
                ungroup()->r

        invisible(r)
}
