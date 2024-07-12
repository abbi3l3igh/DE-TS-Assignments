/*
	Ensureing I am in the correct context
*/
USE portfolio;
GO

/*
	Creating my Stock and ETF Metrics
		- total return
		- cumulative return
		- volitality
		- ten day moving average
		- one hundred day moving average
		- Sharpe ratio
		- (Beta) (I couldn't figure out how to calculate this value so for now it is left out and I'll add it in later if I have time)
*/

WITH deviations AS (
	SELECT SQUARE((stock_close_price - (AVG(stock_close_price) OVER (ORDER BY stock_ticker)))) AS dev
	FROM stocks
	GROUP BY stock_close_price, stock_ticker
), covariance AS(
	SELECT s.stock_timestamp AS [date], 
		CASE 
			WHEN ((COUNT(s.stock_close_price) OVER 
				(PARTITION BY s.stock_ticker ORDER BY s.stock_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW))- 1) = 0 THEN
				(s.stock_close_price - (AVG(s.stock_close_price) OVER 
				(PARTITION BY s.stock_ticker ORDER BY s.stock_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW))) /
				(COUNT(s.stock_close_price) OVER 
				(PARTITION BY s.stock_ticker ORDER BY s.stock_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW))
			WHEN s.stock_timestamp = n.ndx_timestamp THEN
				(s.stock_close_price - (AVG(s.stock_close_price) OVER 
				(PARTITION BY s.stock_ticker ORDER BY s.stock_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)) *
				n.ndx_close_price - (AVG(n.ndx_close_price) OVER 
				(PARTITION BY n.ndx_ticker ORDER BY n.ndx_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW))) /
				((COUNT(s.stock_close_price) OVER 
				(PARTITION BY s.stock_ticker ORDER BY s.stock_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW))- 1)
			ELSE 
				(s.stock_close_price - (AVG(s.stock_close_price) OVER 
				(PARTITION BY s.stock_ticker ORDER BY s.stock_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW))) /
				((COUNT(s.stock_close_price) OVER 
				(PARTITION BY s.stock_ticker ORDER BY s.stock_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW))-1)
		END AS covar
	FROM stocks s, ndx n
) SELECT stock_ticker,
		stock_timestamp,
		(SUM(((stock_close_price * stock_shares) - 16666.67)/16666.67) OVER (ORDER BY stock_ticker)) AS total_return,
		(SUM(stock_close_price * stock_shares) OVER (ORDER BY stock_timestamp)) / 16666.67 AS cumulative_return,
		AVG(stock_close_price * stock_shares) OVER 
			(PARTITION BY stock_ticker ORDER BY stock_timestamp ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) / 16666.67 AS moving_average_10,
		AVG(stock_close_price * stock_shares) OVER 
			(PARTITION BY stock_ticker ORDER BY stock_timestamp ROWS BETWEEN 99 PRECEDING AND CURRENT ROW) / 16666.67 AS moving_average_100,
		CAST(SQRT(SUM(dev)/COUNT(dev)) AS DECIMAL (18, 2)) AS volatility,
		-- I'm going to use 3% as my risk free rate as I am unsure how to calculate this and all the example I saw were
		-- I'm also going to use 10% as the expected return
		((SUM(stock_close_price * stock_shares)*.1) - (SUM(stock_close_price * stock_shares)*.03) )/(AVG(dev)* stock_shares) AS sharpe_ratio,
				(stock_close_price - LAG(stock_close_price) OVER (PARTITION BY stock_ticker ORDER BY stock_timestamp)) / 
		LAG(stock_close_price) OVER (PARTITION BY stock_ticker ORDER BY stock_timestamp) * 100 AS percent_change,
		(SUM((stock_close_price * stock_shares)/ 16666.67) OVER (PARTITION BY YEAR(stock_timestamp) ORDER BY stock_ticker)) AS annual_return,
		covar/im.volitality AS beta
INTO StockAndETFMetrics
FROM stocks s, deviations d, covariance c, IndexMetrics im
GROUP BY stock_ticker, s.stock_timestamp, stock_close_price, stock_shares, covar, im.volitality
ORDER BY stock_ticker;

SELECT * FROM StockAndETFMetrics ORDER BY stock_timestamp;
/*
	Creating my Portfolio Metrics
		- Annual return
		- Total return
		- volitality
		- Sharpe ratio
*/

WITH returnPerStockPerYear AS (
	SELECT (SUM((stock_close_price * stock_shares)/ 16666.67) OVER (PARTITION BY YEAR(stock_timestamp) ORDER BY YEAR(stock_timestamp))) AS annual_return,
		YEAR(stock_timestamp) AS [year]
	FROM stocks
	GROUP BY YEAR(stock_timestamp), stock_ticker, stock_close_price, stock_shares
) SELECT
		DISTINCT rs.annual_return,
		MAX(se.cumulative_return) AS total_return,
		CAST(AVG(se.volatility) AS DECIMAL (18, 2)) AS volatility, -- FIX
		CAST(AVG(se.sharpe_ratio) AS DECIMAL (18, 2)) AS sharpe_ratio -- FIX
INTO PortfolioMetrics
FROM StockAndETFMetrics se, returnPerStockPerYear rs
GROUP BY rs.annual_return;

SELECT 
	DISTINCT YEAR(sm.stock_timestamp) AS [year],
	pm.annual_return AS annual_return,
	pm.total_return AS total_return,
	pm.volatility AS volatility,
	pm.sharpe_ratio AS sharpe_ratio
INTO FormattedPortMetrics
FROM PortfolioMetrics pm , StockAndETFMetrics sm;

select * from FormattedPortMetrics;


/*
	Creating my Foreign Exchange Metrics
		- Total return
		- Cumulative return
		- Percent change
*/

SELECT 
	eurousd_timestamp,
	SUM(((eurousd_close_price*15576)- 16666.67) / 16666.67) OVER (PARTITION BY eurousd_ticker) AS total_return,
	SUM(((eurousd_close_price*15576)- 16666.67) / 16666.67) OVER (ORDER BY eurousd_timestamp) AS cumulative_return,
	(eurousd_close_price - LAG(eurousd_close_price) OVER (ORDER BY eurousd_timestamp)) / 
		LAG(eurousd_close_price) OVER (ORDER BY eurousd_timestamp) * 100 AS percent_change
INTO forexMetrics
FROM eurousd
GROUP BY eurousd_timestamp, eurousd_close_price, eurousd_ticker;

/*
	Creating my Index Metrics
		- Price Index
		- Volitality
		- Total stock market index
*/

WITH deviations AS (
	SELECT SQUARE((ndx_close_price - (AVG(ndx_close_price) OVER (ORDER BY ndx_ticker)))) AS dev
	FROM ndx
	GROUP BY ndx_close_price, ndx_ticker
) SELECT 
	ndx_timestamp AS time_stamp,
	AVG(ndxt_close_price) OVER 
		(PARTITION BY ndxt_ticker ORDER BY ndxt_timestamp ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) / 6539.42 AS price_index,
	CAST(SQRT(SUM(dev)/COUNT(dev)) AS DECIMAL (18, 2)) AS volitality,
	AVG(ndx_close_price) OVER 
		(PARTITION BY ndx_ticker ORDER BY ndx_timestamp ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) / 12066.27 AS comparision_stockMarket10,
	AVG(ndx_close_price) OVER 
		(PARTITION BY ndx_ticker ORDER BY ndx_timestamp ROWS BETWEEN 99 PRECEDING AND CURRENT ROW) / 12066.27 AS comparision_stockMarket100,
	((SUM(ndx_close_price) OVER 
		(PARTITION BY ndx_ticker ORDER BY ndx_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW))- 12085.67) / 12085.67 AS cum_ret
INTO IndexMetrics
FROM ndx n, deviations d, ndxt nt
WHERE ndx_timestamp = ndxt_timestamp
GROUP BY ndx_close_price, ndxt_close_price, ndx_timestamp, ndx_ticker, ndxt_timestamp, ndxt_ticker;
GO

/*
	Drop Table statements
*/

DROP TABLE StockAndETFMetrics;
DROP TABLE PortfolioMetrics;
DROP TABLE FormattedPortMetrics;
DROP TABLE forexMetrics;
