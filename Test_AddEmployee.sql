USE [EmployeesDB];
GO

SET NOCOUNT ON;

DECLARE @PositionId INT,
		@ProjectId INT,
		@EmployeeId INT,
		@EffectiveFrom DATE

BEGIN TRY

BEGIN TRANSACTION;

TRUNCATE TABLE dbo.EmployeePosition
TRUNCATE TABLE dbo.EmployeeProject
TRUNCATE TABLE dbo.Salary
TRUNCATE TABLE dbo.WorkPeriod
DELETE dbo.Employee WHERE SuperiorId IS NOT NULL
DELETE dbo.Employee WHERE SuperiorId IS NULL


SELECT @PositionId = PositionId from dbo.Position where PositionName='Chief Executive Officer'
SELECT @ProjectId = ProjectId from dbo.Project where ProjectName='Company Management'
SELECT @EffectiveFrom = GETDATE()

PRINT 'Test adding a director'
exec dbo.AddEmployee 'Donald', 'Trump', @PositionId, @ProjectId, default, 10000, @EffectiveFrom, @EmployeeId OUT
PRINT 'Success'
-----------------------------------------------------------------
PRINT 'Test the director has been added to dbo.Employee'
DECLARE @SuperiorId INT
select @EmployeeId=EmployeeId, @SuperiorId=SuperiorId from dbo.Employee where FirstName='Donald' and LastName='Trump'
IF (@EmployeeId IS NOT NULL AND @SuperiorId IS NULL)
	PRINT 'Success'
ELSE
	RAISERROR('FAIL', 11, 1)
------------------------------------------------------------------
PRINT 'Test the director has been added to dbo.EmployeePosition'
DECLARE @PositionName VARCHAR(40)

select @PositionName = pos.PositionName from dbo.EmployeePosition empPos
join dbo.Position pos on empPos.PositionId = pos.PositionId
where empPos.EmployeeId = @EmployeeId and empPos.EffectiveFrom = @EffectiveFrom and empPos.EffectiveTo IS NULL

IF (@PositionName = 'Chief Executive Officer')
	PRINT 'Success'
ELSE
	RAISERROR('FAIL', 11, 1)
------------------------------------------------------------------
PRINT 'Test the director has been added to dbo.EmployeeProject'
DECLARE @ProjectName VARCHAR(40)

select @ProjectName = proj.ProjectName from dbo.EmployeeProject empProj
join dbo.Project proj on empProj.ProjectId = proj.ProjectId
where empProj.EmployeeId = @EmployeeId and empProj.EffectiveFrom = @EffectiveFrom and empProj.EffectiveTo IS NULL

IF (@ProjectName = 'Company Management')
	PRINT 'Success'
ELSE
	RAISERROR('FAIL', 11, 1)
------------------------------------------------------------------
PRINT 'Test the director has salary'
DECLARE @MonthlyPay MONEY

select @MonthlyPay = sal.MonthlyPay from dbo.Salary sal
where sal.EmployeeId = @EmployeeId and sal.EffectiveFrom = @EffectiveFrom and sal.EffectiveTo IS NULL

IF (@MonthlyPay = 10000)
	PRINT 'Success'
ELSE
	RAISERROR('FAIL', 11, 1)
------------------------------------------------------------------
PRINT 'Test the director has been hired'
IF 
	EXISTS(
			select 1 from dbo.WorkPeriod wp
			where wp.EmployeeId = @EmployeeId and wp.EffectiveFrom = @EffectiveFrom and wp.EffectiveTo IS NULL
	)
	PRINT 'Success'
ELSE
	RAISERROR('FAIL', 11, 1)
------------------------------------------------------------------
PRINT 'Test adding a subordinate'
SELECT @PositionId = PositionId from dbo.Position where PositionName='Project Manager'
SELECT @ProjectId = ProjectId from dbo.Project where ProjectName='Project A'
SELECT @SuperiorId = EmployeeId from dbo.Employee where FirstName = 'Donald'
exec dbo.AddEmployee 'Bill', 'Gates', @PositionId, @ProjectId, @SuperiorId, 5000, @EffectiveFrom, @EmployeeId OUT
PRINT 'Success'
------------------------------------------------------------------
PRINT 'Test the subordinate has a superior'
IF	EXISTS(
		select 1 from dbo.Employee where EmployeeId = @EmployeeId and SuperiorId=@SuperiorId
	)
	PRINT 'Success'
ELSE
	RAISERROR('FAIL', 11, 1)

ROLLBACK TRANSACTION;

END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE()

	IF XACT_STATE() != 0
		ROLLBACK TRANSACTION;

END CATCH

------------------------------------------------------------------
PRINT 'Test the same employee can''t be added twice'
BEGIN TRY
	BEGIN TRAN
	exec dbo.AddEmployee 'Donald', 'Trump', 1, 1, default, 10000
	exec dbo.AddEmployee 'Donald', 'Trump', 1, 1, default, 10000
	PRINT 'FAIL'
END TRY
BEGIN CATCH
	PRINT 'Success'
END CATCH

/*
select * from dbo.Employee
select * from dbo.EmployeePosition
select * from dbo.EmployeeProject
select * from dbo.WorkPeriod
select * from dbo.Salary
select * from Position
select * from Project

delete dbo.EmployeePosition where EmployeeId=2
delete dbo.EmployeeProject where EmployeeId=2
delete dbo.WorkPeriod where EmployeeId=2
delete dbo.Salary where EmployeeId=2
delete dbo.Employee where EmployeeId=2
*/

