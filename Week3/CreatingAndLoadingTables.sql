CREATE DATABASE portfolio;
GO
USE portfolio;
GO

/*
	Creating my stocks tabe which holds all of my stock and ETF data
*/
CREATE TABLE stocks (
  stock_id INT IDENTITY NOT NULL,
  stock_trading_volume INT NOT NULL,
  stock_volume_weighted_avg DECIMAL(18,2) NOT NULL,
  stock_open_price DECIMAL(18,2) NOT NULL,
  stock_close_price DECIMAL(18,2) NOT NULL,
  stock_highest_price DECIMAL(18,2) NOT NULL,
  stock_lowest_price DECIMAL(18,2) NOT NULL,
  stock_timestamp DATETIME NOT NULL,
  stock_number_transactions INT NOT NULL,
  stock_ticker VARCHAR(10) NOT NULL,
  stock_shares INT NOT NULL,
  PRIMARY KEY (stock_id)
); 

/*
	Loading my stock and ETF data from my csvs created in python
*/

BULK INSERT dbo.stocks
FROM 'C:\Users\asmit\SkillStorm\DE-TS-Assignments\Week3\luxh_dump.csv'
WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
GO

BULK INSERT dbo.stocks
FROM 'C:\Users\asmit\SkillStorm\DE-TS-Assignments\Week3\aapl_dump.csv'
WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
GO

BULK INSERT dbo.stocks
FROM 'C:\Users\asmit\SkillStorm\DE-TS-Assignments\Week3\dfsi_dump.csv'
WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
GO

BULK INSERT dbo.stocks
FROM 'C:\Users\asmit\SkillStorm\DE-TS-Assignments\Week3\gme_dump.csv'
WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
GO

BULK INSERT dbo.stocks
FROM 'C:\Users\asmit\SkillStorm\DE-TS-Assignments\Week3\lulu_dump.csv'
WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
GO

/*
	Creating my foreign exchange table
*/

CREATE TABLE eurousd (
  eurousd_id INT IDENTITY NOT NULL,
  eurousd_trading_volume INT NOT NULL,
  eurousd_volume_weighted_avg DECIMAL(18,2) NOT NULL,
  eurousd_open_price DECIMAL(18,2) NOT NULL,
  eurousd_close_price DECIMAL(18,2) NOT NULL,
  eurousd_highest_price DECIMAL(18,2) NOT NULL,
  eurousd_lowest_price DECIMAL(18,2) NOT NULL,
  eurousd_timestamp DATETIME NOT NULL,
  eurousd_number_transactions INT NOT NULL,
  eurousd_ticker VARCHAR(10) NOT NULL,
  PRIMARY KEY (eurousd_id)
); 
GO

/*
	Loading my Forex data from my csv created in python
*/

BULK INSERT dbo.eurousd
FROM 'C:\Users\asmit\SkillStorm\DE-TS-Assignments\Week3\eurusd_dump.csv'
WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
GO
USE portfolio;
GO
/*
	Creating my market index table
*/

CREATE TABLE ndx (
  ndx_id INT IDENTITY NOT NULL,
  ndx_open_price DECIMAL(18,2) NOT NULL,
  ndx_close_price DECIMAL(18,2) NOT NULL,
  ndx_highest_price DECIMAL(18,2) NOT NULL,
  ndx_lowest_price DECIMAL(18,2) NOT NULL,
  ndx_timestamp DATETIME NOT NULL,
  ndx_ticker VARCHAR(10) NOT NULL,
  PRIMARY KEY (ndx_id)
);
GO

/*
	Loading my market index data from my csv created in python
*/

BULK INSERT dbo.ndx
FROM 'C:\Users\asmit\SkillStorm\DE-TS-Assignments\Week3\ndx_dump.csv'
WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
GO

/*
	Creating my price index table
*/

CREATE TABLE ndxt (
  ndxt_id INT IDENTITY NOT NULL,
  ndxt_open_price DECIMAL(18,2) NOT NULL,
  ndxt_close_price DECIMAL(18,2) NOT NULL,
  ndxt_highest_price DECIMAL(18,2) NOT NULL,
  ndxt_lowest_price DECIMAL(18,2) NOT NULL,
  ndxt_timestamp DATETIME NOT NULL,
  ndxt_ticker VARCHAR(10) NOT NULL,
  PRIMARY KEY (ndxt_id)
);
GO

/*
	Loading my price index data from my csv created in python
*/

BULK INSERT dbo.ndxt
FROM 'C:\Users\asmit\SkillStorm\DE-TS-Assignments\Week3\ndxt_dump.csv'
WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;

/*
	Drop Table statements
*/
DROP TABLE stocks;
DROP TABLE ndx;