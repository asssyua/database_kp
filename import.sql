
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;
---
SELECT * FROM Tickets FOR JSON PATH, INCLUDE_NULL_VALUES

DECLARE @sql varchar(1000)
SET @sql = 'bcp "SELECT * FROM Tickets ' + 
    'FOR JSON PATH, INCLUDE_NULL_VALUES" ' +
    'queryout  "D:\import\tickets.json" ' + 
    '-c -S LAPTOP-F1RJ50JM -d Busstation_db -T'
EXEC sys.XP_CMDSHELL @sql
GO

select @@SERVERNAME;


CREATE OR ALTER PROCEDURE SaveTableDataToJson
    @tableName NVARCHAR(128)
AS
BEGIN
    DECLARE @fileName NVARCHAR(128);
    SET @fileName = REPLACE(@tableName, ' ', '') + '.json';

    DECLARE @sql NVARCHAR(1000);
    SET @sql = 'bcp "SELECT * FROM ' + QUOTENAME(@tableName) + ' ' +
               'FOR JSON PATH, INCLUDE_NULL_VALUES" ' +
               'queryout "D:\' + @fileName + '" ' +
               '-c -S LAPTOP-F1RJ50JM -d Busstation_db -T';
    EXEC sys.XP_CMDSHELL @sql;
END;

EXEC SaveTableDataToJson @tableName = 'Tickets';

select * from Tickets


CREATE TABLE #csv_temp (
    ID_bus NVARCHAR(100),
	Bus_brand NVARCHAR(100),
	Release_year NVARCHAR(100),
	Seats_number NVARCHAR(100)
);
--

bulk insert #csv_temp
from 'D:\import\import_bus.csv'
with (Fieldterminator = ',', RowTerminator = '\n', CODEPAGE = '1251')
--  
select * from #csv_temp;
