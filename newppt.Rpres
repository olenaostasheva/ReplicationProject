The 52-weeek High and Momentum Investing: A Partial Replication of George and Hwang (2004)
========================================================
author: Wenhao Yu and Olena Ostasheva
date: May 9th, 2016
autosize: true

Summary of the paper and literature overview
========================================================
- Random walk vs. predictable returns
- Individual and industry returns
- 52 week Theory: stock’s proximity to 52 week high is an indicator of future returns
- Attribution to anchoring bias


3 different strategies
========================================================

- **(6,6) Portfolio strategy: portfolio formed based on past 6-month returns, and positions held for 6 months**

- JT: long top 30%, short bottom 30% of best performing stocks
- MG: long top 30%, short bottom 30% of stocks in the best performing industries
- GH: long top 30%, short bottom 30% of stocks with highest 52 week ratios
(current stock price / 52 week high stock price)


Data and method comparison
========================================================
|           **George and Hwang**            |            **Wenhao and Olena**            |
|------------------------------------------:|:-------------------------------------------|
| CRSP data                                 | 1500 largest cap US stocks                 |
| 1963-2001                                 | 1998-2007*                                 |
| 20 industries                             | 69 industries                              |
| portfolio: winners/losers - top/bottom 30%| portfolio: winners/losers - top/bottom 33% |


- Modernity of data = real world application
- First portfolio is not formed until June 1998 (6 months after the first date available)


Our method
========================================================

1. Gather and clean the data using  *gather_data* function
2. Find past stock/industry returns and 52 week high ratio

   $52week.high.ratio = current.price/52week.high.price$

3. Get rid of all the rows with NA returns
4. Rank the returns/ratios into 3 ntiles
5. Gather data into monthly --> data for the last trading day of each month
6. Find the future mean returns of the portfolios for each month (long Winners, short Losers)
7. Tweak: exclude January data, only use January data, do not filter by top 1500


Our replication vs GH: average monthly returns
========================================================
|     **Strategy**               |  **Winner**  |   **Loser**   | **Winner-Loser** |
|-------------------------------:|:------------:|:-------------:|:-----------------|
| JT's individ. stock momemntum  | 1.6% (1.53%) | 1.96% (1.05%) | -0.36% (0.48%)   |
| MG's industry momentum         |    (1.48%)   |       (1.03%) |        (0.45%)   |
| GH's 52-week high              | 2.9% (1.51%) | -0.1% (1.06%) |   2.8% (0.45%)   |


Notes and observations:

- Data is filtered with top.1500 and includes all the months
- JT: Losers outperform winners for our replication (when not filtered by top.1500, winners outperform losers)
- GH: Winners in our replication outperform winners in GH's replication, losers perform poorly in
our replication

Our charts
========================================================
