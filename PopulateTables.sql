﻿USE [EmployeesDB];
GO

SET NOCOUNT ON;

TRUNCATE TABLE dbo.EmployeePosition
TRUNCATE TABLE dbo.EmployeeProject
TRUNCATE TABLE dbo.Salary
DELETE dbo.Employee WHERE SuperiorId IS NOT NULL
DELETE dbo.Employee WHERE SuperiorId IS NULL

DECLARE @CEOId INT
exec dbo.AddEmployee 'Donald', 'Trump', 5 /*CEO*/, 3 /*Comp. Mgmt*/, default, 10000, '1 Jan 2015', @CEOId OUT

-- Project A resources
DECLARE @PMAId INT
exec dbo.AddEmployee 'Bill', 'Gates', 4 /*PM*/, 1 /*Proj. A*/, @CEOId, 5000, '1 Feb 2015', @PMAId OUT

exec dbo.AddEmployee 'Mickey', 'Mouse', 1 /*SD*/, 1 /*Proj. A*/, @PMAId, 3000, '15 Feb 2015'

DECLARE @DonaldDuckId INT
exec dbo.AddEmployee 'Donald', 'Duck', 2 /*QA*/, 1 /*Proj. A*/, @PMAId, 2000, '20 Feb 2015', @DonaldDuckId OUT
exec dbo.AddEmployee 'Goofy', 'Wolf', 3 /*BA*/, 1 /*Proj. A*/, @PMAId, 3500, '25 Feb 2015'
exec dbo.AddEmployee 'Daisy', 'Mouse', 1 /*SD*/, 1 /*Proj. A*/, @PMAId, 3000, '20 Mar 2015'

-- Project B resources
DECLARE @PMBId INT
exec dbo.AddEmployee 'Jackie', 'Chan', 4 /*PM*/, 2 /*Proj. B*/, @CEOId, 6000, '1 Jul 2016', @PMBId OUT

exec dbo.AddEmployee 'Samo', 'Hung', 1 /*SD*/, 2 /*Proj. B*/, @PMBId, 2000, '23 Jul 2016'
exec dbo.AddEmployee 'Bruce', 'Lee', 2 /*SD*/, 2 /*Proj. B*/, @PMBId, 4000, '1 Sep 2016'
exec dbo.AddEmployee 'Chuck', 'Noris', 2 /*QA*/, 2 /*Proj. B*/, @PMBId, 2000, '5 Sep 2016'
exec dbo.AddEmployee 'Jet', 'Lee', 3 /*BA*/, 2 /*Proj. B*/, @PMBId, 1000, '1 Dec 2016'
exec dbo.AddEmployee 'Panda', 'Kung Fu', 3 /*BA*/, 2 /*Proj. B*/, @PMBId, 5000, '1 Apr 2017'

-- Create career for Donald Duck
exec dbo.UpdateEmployee @DonaldDuckId, @MonthlyPay = 2100, @EffectiveFrom = '20 May 2015'
exec dbo.UpdateEmployee @DonaldDuckId, @PositionId = 1 /*SD*/, @EffectiveFrom = '20 Aug 2015'
exec dbo.UpdateEmployee @DonaldDuckId, @MonthlyPay = 2500, @EffectiveFrom = '1 Nov 2015'
exec dbo.UpdateEmployee @DonaldDuckId, @ProjectId = 2, @EffectiveFrom = '2 Jul 2016'
exec dbo.UpdateEmployeeSuperior @DonaldDuckId, @PMBId
exec dbo.DismissEmployee @DonaldDuckId, '1 Mar 2017'
GO