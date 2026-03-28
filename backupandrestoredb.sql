/*
    SQL Server Express backup and restore script for database: testdb

    Usage flow:
    1) Run Section A on the source SQL Server instance to create the backup file.
    2) Copy the .bak file to the destination SQL Server host.
    3) Run Section B on the destination SQL Server instance to restore testdb.
*/

/* ============================== */
/* Section A: Source - BACKUP    */
/* ============================== */
USE [master];
GO

DECLARE @BackupFile NVARCHAR(4000) = N'C:\SqlBackups\testdb_full.bak';

BACKUP DATABASE [testdb]
TO DISK = @BackupFile
WITH
    COPY_ONLY,
    INIT,
    COMPRESSION,
    CHECKSUM,
    STATS = 10;
GO

RESTORE VERIFYONLY
FROM DISK = N'C:\SqlBackups\testdb_full.bak'
WITH CHECKSUM;
GO

/* ========================================================= */
/* Section B: Destination - RESTORE (after copying .bak)     */
/* ========================================================= */
USE [master];
GO

DECLARE @BackupFileRestore NVARCHAR(4000) = N'C:\IncomingBackups\testdb_full.bak';

/*
    First inspect logical file names in the backup.
    Copy the returned LogicalName values into @DataLogicalName and @LogLogicalName.
*/
RESTORE FILELISTONLY
FROM DISK = @BackupFileRestore;
GO

DECLARE @BackupFileRestore2 NVARCHAR(4000) = N'C:\IncomingBackups\testdb_full.bak';
DECLARE @DataLogicalName SYSNAME = N'testdb';
DECLARE @LogLogicalName  SYSNAME = N'testdb_log';

/*
    Adjust physical target paths as needed for your destination server.
    For SQL Server Express, these are often under the instance DATA folder.
*/
DECLARE @DataPhysicalPath NVARCHAR(4000) = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\testdb.mdf';
DECLARE @LogPhysicalPath  NVARCHAR(4000) = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\testdb_log.ldf';
DECLARE @RestoreSql NVARCHAR(MAX);

IF DB_ID(N'testdb') IS NOT NULL
BEGIN
    ALTER DATABASE [testdb] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
END;

SET @RestoreSql = N'
RESTORE DATABASE [testdb]
FROM DISK = N''' + REPLACE(@BackupFileRestore2, '''', '''''') + N'''
WITH
    REPLACE,
    RECOVERY,
    MOVE N''' + REPLACE(@DataLogicalName, '''', '''''') + N''' TO N''' + REPLACE(@DataPhysicalPath, '''', '''''') + N''',
    MOVE N''' + REPLACE(@LogLogicalName, '''', '''''') + N''' TO N''' + REPLACE(@LogPhysicalPath, '''', '''''') + N''',
    STATS = 10;';

EXEC sys.sp_executesql @RestoreSql;

ALTER DATABASE [testdb] SET MULTI_USER;
GO
