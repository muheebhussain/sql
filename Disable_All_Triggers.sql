EXEC sp_msforeachtable '
    DECLARE @triggerName NVARCHAR(MAX)
    DECLARE triggerCursor CURSOR FOR
        SELECT t.name
        FROM sys.triggers t
        INNER JOIN sys.tables tbl ON t.parent_id = tbl.object_id
        WHERE tbl.name = PARSENAME(''?'', 1)
    OPEN triggerCursor
    FETCH NEXT FROM triggerCursor INTO @triggerName
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC(''DISABLE TRIGGER '' + @triggerName + '' ON ?'')
        FETCH NEXT FROM triggerCursor INTO @triggerName
    END
    CLOSE triggerCursor
    DEALLOCATE triggerCursor'

/*
In this query, sp_msforeachtable iterates over each table in the database (represented by the ? placeholder), and for each table, we use a cursor to fetch the names of all triggers associated with that table. We then execute a dynamic SQL query to disable each trigger.

Please note that the sp_msforeachtable procedure is an undocumented system stored procedure in SQL Server, and its behavior may change in future versions. Additionally, you should always exercise caution when disabling triggers, as they may be important for maintaining data integrity in your database. If possible, consider testing this script in a development environment before running it on a production database.
*/
