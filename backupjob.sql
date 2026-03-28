/*
    Weekly full backup script for database: testdb

    Scheduling target:
    - Every Saturday at 14:00

    Notes:
    - SQL Server Express does not include SQL Server Agent scheduling.
    - Run this script via Windows Task Scheduler using sqlcmd at the required time.
    - Ensure the backup directory exists and SQL Server service account can write to it.
*/

SET NOCOUNT ON;

DECLARE @BackupDirectory NVARCHAR(4000) = N'C:\SqlBackups\';
DECLARE @BackupFileName NVARCHAR(128) = N'testdb_' + CONVERT(CHAR(8), GETDATE(), 112) + N'.bak';
DECLARE @BackupFilePath NVARCHAR(4000);

IF RIGHT(@BackupDirectory, 1) <> N'\'
BEGIN
    SET @BackupDirectory = @BackupDirectory + N'\';
END;

SET @BackupFilePath = @BackupDirectory + @BackupFileName;

IF DB_ID(N'testdb') IS NULL
BEGIN
    THROW 50001, 'Database testdb does not exist on this instance.', 1;
END;

BACKUP DATABASE [testdb]
TO DISK = @BackupFilePath
WITH
    CHECKSUM,
    STATS = 10;

RESTORE VERIFYONLY
FROM DISK = @BackupFilePath
WITH CHECKSUM;

SELECT @BackupFilePath AS backup_file_created;
