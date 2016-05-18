GH_ratio <- function(data) {
        data %>%
                group_by(symbol) %>%
                arrange(symbol, date) %>%
                mutate(highest = roll_max(price, 252, fill = NA, align = "right")) %>%
                ungroup() %>%
                mutate(wh_52_ratio = price/highest) %>%
                filter(!is.na(wh_52_ratio)) ->r

        invisible(r)
}
