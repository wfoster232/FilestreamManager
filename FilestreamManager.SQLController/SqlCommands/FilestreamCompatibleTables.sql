SELECT TableName = '[' + [dbSchema].[name] + '].[' + [dbTable].[name] + ']'
	, FilestreamAlreadyEnabled = ISNULL(FilestreamCheck.HasFilestreamColumn, 0)
FROM [$DATABASE$].[sys].[tables] AS dbTable
	INNER JOIN [$DATABASE$].[sys].[schemas] AS dbSchema ON [dbSchema].[schema_id] = [dbTable].[schema_id]
	OUTER APPLY
	(
		-- Table does not currently have a filestream column enabled
		SELECT TOP 1 1 AS HasFilestreamColumn
		FROM [$DATABASE$].[sys].[columns] AS dbColumn
			INNER JOIN [$DATABASE$].[sys].[types] AS dataType ON [dataType].[system_type_id] = [dbColumn].[system_type_id]
		WHERE [dbTable].[object_id] = [dbColumn].[object_id]
			AND [dataType].[name] = 'varbinary' AND [dbColumn].[max_length] = -1
			AND [dbColumn].[is_filestream] = 1
	) AS FilestreamCheck
WHERE EXISTS
	(
		-- Table has at least one valid filestream compatible column
		SELECT TOP 1 1 AS ValidColumn
		FROM [$DATABASE$].[sys].[columns] AS dbColumn
			INNER JOIN [$DATABASE$].[sys].[types] AS dataType ON [dataType].[system_type_id] = [dbColumn].[system_type_id]
		WHERE [dbTable].[object_id] = [dbColumn].[object_id]
			AND [dataType].[name] = 'varbinary' AND [dbColumn].[max_length] = -1
	)