USE qa;
GO

BULK INSERT dbo.categories 
FROM 'C:\Users\asmit\SkillStorm\PythonTraining\ProfNotes\20240617-DE-TS-LectureMaterials\SQL\Data\retail_db\data\categories.csv' 
WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
