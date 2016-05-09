#Find returns for the 52 week high strategy

#1. Gather the data

gather_data <- function(symbols, years){

        require(ws.data)

        gathered <- data.frame()

        #open up all the daily data files for all years
        for( i in years ){

                file.name <- paste("daily", i, sep = ".")
                data(list = file.name) #create a data list of daily files

                #combine all the daily data in a data frame
                gathered <- rbind(gathered, subset(eval(parse(text=file.name)), symbol %in% symbols))
        }

        #rename v.date to date, makes more sense
        gathered <- rename(gathered, date = v.date)

        #join daily data with secref that contains industry returns
        gathered <- left_join(select(gathered,id,symbol,date,price,tret), select(secref, id, m.ind), by = "id")

        #1) create a new column for year and mon-year variable and 2)attach existing data to yearly
        gathered <- left_join(mutate(gathered, year = lubridate::year(date), month = paste(lubridate::month(date, TRUE, TRUE), year, sep = "-")),
                              select(yearly, id, year, top.1500),
                              by = c("year", "id"))

        #make gathered data a tbl_df
        gathered<-tbl_df(gathered)

        #clean data: get rid of stocks with high returns
        #gets rid of 982 lines of code where tret is less than 15
        #filter out only top 1500 companies
        #gathered<-filter(gathered,tret<15)
        gathered<-filter(gathered, top.1500==TRUE)

        #find past and forward 6 months returns to be used later in calculations of
        # MG and JT strategies
        gathered<-gathered %>% group_by(symbol) %>%
                mutate(ret.6.0.m=roll_prod(tret+1, 126,fill=NA,align="right")-1) %>%
                mutate(ret.0.6.m=roll_prod(lead(tret,n=1)+1,126,fill=NA, align="left")-1) %>%
                ungroup()


        # add a test case
        invisible(gathered)
}

x <- gather_data(symbols=secref$symbol,1998:2007)
View(x)
unique(x$symbol)


#2. Find the 52 week high ratio
gather_daily_GH <- function(data) {
        data %>%
                group_by(symbol) %>%
                arrange(symbol, date) %>%
                mutate(highest = roll_max(price, 252, fill = NA, align = "right")) %>%
                ungroup() %>%
                mutate(wh_52_ratio = price/highest) %>%
                filter(!is.na(wh_52_ratio)) ->r

        invisible(r)
}

ratio_daily_GH<-gather_daily_GH(x)

#3. Rank the ratios into 3 groups

GH_rank<- function(data) {

        data %>% group_by(date) %>%
        mutate(wh.52.class = as.character(ntile(wh_52_ratio, n = 3))) %>%
        mutate(wh.52.class= ifelse(wh.52.class == "1", "Losers_GH", wh.52.class)) %>%
        mutate(wh.52.class = ifelse(wh.52.class == "3", "Winners_GH", wh.52.class)) %>%
        mutate(wh.52.class = factor(wh.52.class, levels = c("Losers_GH", "2", "Winners_GH"))) %>%
        ungroup()->r

        invisible(r)
        }

daily_ranks_GH<-GH_rank(ratio_daily_GH)

#4. Gather daily returns into monthly, by selecting the last trading day of the month

gather_monthly <- function(x){
        ## Filter out the last trading day of the month
        monthly <- x %>% group_by(month) %>%
                filter(min_rank(desc(date)) == 1)
        return(monthly)
}

monthly_returns_GH<-gather_monthly(daily_ranks_GH)
View(monthly_returns_GH)
summary(monthly_returns)

#5. Form a portfolio of winners and losers.
#Calculate forward 6 months returns for each stock for the last trading day of each month

#Summarize the mean returns for each month for each wh.52.class group
#Make sure to ommit all the NAs
win_minus_los<-monthly_returns_GH %>%
        na.omit() %>%
        group_by(month,wh.52.class) %>%
        summarize(mean_return=mean(ret.0.6.m))
View(win_minus_los)


portfolio_returns_GH<-win_minus_los %>%
        spread(key=wh.52.class,value=mean_return) %>%
        mutate(diff=Winners_GH-Losers_GH) %>%
        select(month, Winners_GH, Losers_GH, diff)
View(portfolio_returns_GH)

#Mean of Winners returns over the years
mean(portfolio_returns_GH$Winners_GH)/6

#Mean of Losers returns over the years
mean(portfolio_returns_GH$Losers_GH)/6

#Mean of the difference in returns over the years
mean(portfolio_returns_GH$diff)/6


#Graph the returns in a bar plot

#Graph the SPREAD
portfolio_returns_GH %>% ggplot(aes(x=month,diff)) + scale_y_continuous(limits = c(-1,1))+geom_bar(stat="identity")

#Graph the WINNERS
portfolio_returns_GH %>% ggplot(aes(x=month,Winners_GH)) + scale_y_continuous(limits = c(-1,1))+geom_bar(stat="identity")

#Graphs the LOSERS
portfolio_returns_GH %>% ggplot(aes(x=month,Losers_GH)) + scale_y_continuous(limits = c(-1,1))+geom_bar(stat="identity")

############################
####Apply some filters######

#Table 2: tweak JANUARY
#January returns excluded
#Filter out the month of January from the monthly data
View(filtered)

all_but_Jan_GH<-filter(filtered, month!="Jan-1998" & month!="Jan-1999" & month!="Jan-2000" & month!="Jan-2001" & month!="Jan-2002" & month!="Jan-2003"& month!="Jan-2004"& month!="Jan-2005" & month!="Jan-2006" & month!="Jan-2007")
View(all_but_Jan_GH)

#Find the returns for all the months but January
win_minus_los<-all_but_Jan_GH %>%
        na.omit() %>%
        group_by(month,wh.52.class) %>%
        summarize(mean_return=mean(ret.0.6.m))

View(win_minus_los)

portfolio_returns_GH_noJan<-win_minus_los %>%
        spread(key=wh.52.class,value=mean_return) %>%
        mutate(diff=Winners_GH-Losers_GH) %>%
        select(month, Winners_GH, Losers_GH, diff)

View(portfolio_returns_GH_noJan)

#Find the mean returns for Winner/Loser portfolios and for the
#difference between the two portfolios

#Winner portfolio
#23.7% return
mean(portfolio_returns_GH_noJan$Winners_GH)

#Loser portfolio
#-3.04% return
mean(portfolio_returns_GH_noJan$Losers_GH)

#Diff between the two
#22.2% net return
mean(portfolio_returns_GH_noJan$diff)




######################
#Table 2: #JANUARY ONLY
#Use data only for the month of January
JanOnly_GH<-filter(filtered, format.Date(date, "%m")=="01")
View(JanOnly_GH)

#Find the mean returns for the month of January
win_minus_los<-JanOnly_GH %>%
        na.omit() %>%
        group_by(month,wh.52.class) %>%
        summarize(mean_return=mean(ret.0.6.m))

View(win_minus_los)

portfolio_returns_GH_JanOnly<-win_minus_los %>%
        spread(key=wh.52.class,value=mean_return) %>%
        mutate(diff=Winners_GH-Losers_GH) %>%
        select(month, Winners_GH, Losers_GH, diff)

View(portfolio_returns_GH_JanOnly)

#Find the mean returns for Winner/Loser portfolios and for the
#difference between the two portfolios

#Winner portfolio
#Decreased to 11.6%
mean(portfolio_returns_GH_JanOnly$Winners_GH)

#Loser portfolio
#Increased to 5.8%
mean(portfolio_returns_GH_JanOnly$Losers_GH)

#Diff between the two
#Decreased to 5.8%
mean(portfolio_returns_GH_JanOnly$diff)


#Chart the 3 portfolio returns
par(mfrow=c(1, 3))


