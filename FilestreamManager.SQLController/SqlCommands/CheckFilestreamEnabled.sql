SELECT CAST(CASE WHEN [value] > 0 THEN 1 ELSE 0 END AS BIT) AS IsFilestreamEnabled
FROM sys.configurations AS serverConfig
WHERE name = 'filestream access level';