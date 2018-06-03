USE [EmployeesDB];
GO

SET NOCOUNT ON;

TRUNCATE TABLE dbo.EmployeePosition
TRUNCATE TABLE dbo.EmployeeProject
TRUNCATE TABLE dbo.Salary
TRUNCATE TABLE dbo.WorkPeriod
DELETE dbo.Employee WHERE SuperiorId IS NOT NULL
DELETE dbo.Employee WHERE SuperiorId IS NULL

DECLARE @CEOId INT
exec dbo.AddEmployee 'Donald', 'Trump', 5 /*CEO*/, 3 /*Comp. Mgmt*/, default, 10000, default, @CEOId OUT

-- Project A resources
DECLARE @PMAId INT
exec dbo.AddEmployee 'Bill', 'Gates', 4 /*PM*/, 1 /*Proj. A*/, @CEOId, 5000, default, @PMAId OUT

exec dbo.AddEmployee 'Mickey', 'Mouse', 1 /*SD*/, 1 /*Proj. A*/, @PMAId, 3000
exec dbo.AddEmployee 'Daisy', 'Mouse', 1 /*SD*/, 1 /*Proj. A*/, @PMAId, 3000
exec dbo.AddEmployee 'Donald', 'Duck', 2 /*QA*/, 1 /*Proj. A*/, @PMAId, 2000
exec dbo.AddEmployee 'Goofy', 'Wolf', 3 /*BA*/, 1 /*Proj. A*/, @PMAId, 3500

-- Project B resources
DECLARE @PMBId INT
exec dbo.AddEmployee 'Jackie', 'Chan', 4 /*PM*/, 2 /*Proj. B*/, @CEOId, 6000, default, @PMBId OUT

exec dbo.AddEmployee 'Samo', 'Hung', 1 /*SD*/, 2 /*Proj. B*/, @PMBId, 2000
exec dbo.AddEmployee 'Bruce', 'Lee', 2 /*SD*/, 2 /*Proj. B*/, @PMBId, 4000
exec dbo.AddEmployee 'Chuck', 'Noris', 2 /*QA*/, 2 /*Proj. B*/, @PMBId, 2000
exec dbo.AddEmployee 'Jet', 'Lee', 3 /*BA*/, 2 /*Proj. B*/, @PMBId, 1000
exec dbo.AddEmployee 'Panda', 'Kung Fu', 3 /*BA*/, 2 /*Proj. B*/, @PMBId, 5000