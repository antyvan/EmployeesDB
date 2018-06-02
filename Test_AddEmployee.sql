DECLARE @PositionId INT,
		@ProjectId INT,
		@EmployeeId INT,
		@EffectiveFrom DATE


SELECT @PositionId = PositionId from dbo.Position where PositionName='Chief Executive Officer'
SELECT @ProjectId = ProjectId from dbo.Project where ProjectName='Company Management'
SELECT @EffectiveFrom = GETDATE()

PRINT 'Test adding a director'
BEGIN TRY
	exec dbo.AddEmployee 'Donald', 'Trump', @PositionId, @ProjectId, default, 10000, @EffectiveFrom, @EmployeeId OUT
	PRINT 'Success'
END TRY
BEGIN CATCH
	PRINT 'FAIL'
	RETURN
END CATCH
-----------------------------------------------------------------
PRINT 'Test the director has been added to dbo.Employee'
DECLARE @SuperiorId INT

select @EmployeeId=EmployeeId, @SuperiorId=SuperiorId from dbo.Employee where FirstName='Donald' and LastName='Trump'
IF (@EmployeeId IS NOT NULL AND @SuperiorId IS NULL)
	PRINT 'Success'
ELSE
BEGIN
	PRINT 'FAIL'
	RETURN
END
------------------------------------------------------------------
PRINT 'Test the director has been added to dbo.EmployeePosition'
DECLARE @PositionName VARCHAR(40)

select @PositionName = pos.PositionName from dbo.EmployeePosition empPos
join dbo.Position pos on empPos.PositionId = pos.PositionId
where empPos.EmployeeId = @EmployeeId and empPos.EffectiveFrom = @EffectiveFrom and empPos.EffectiveTo IS NULL

IF (@PositionName = 'Chief Executive Officer')
	PRINT 'Success'
ELSE
BEGIN
	PRINT 'FAIL'
	RETURN
END
------------------------------------------------------------------
PRINT 'Test the director has been added to dbo.EmployeeProject'
DECLARE @ProjectName VARCHAR(40)

select @ProjectName = proj.ProjectName from dbo.EmployeeProject empProj
join dbo.Project proj on empProj.ProjectId = proj.ProjectId
where empProj.EmployeeId = @EmployeeId and empProj.EffectiveFrom = @EffectiveFrom and empProj.EffectiveTo IS NULL

IF (@ProjectName = 'Company Management')
	PRINT 'Success'
ELSE
BEGIN
	PRINT 'FAIL'
	RETURN
END
------------------------------------------------------------------
PRINT 'Test the director has salary'
DECLARE @MonthlyPay MONEY

select @MonthlyPay = sal.MonthlyPay from dbo.Salary sal
where sal.EmployeeId = @EmployeeId and sal.EffectiveFrom = @EffectiveFrom and sal.EffectiveTo IS NULL

IF (@MonthlyPay = 10000)
	PRINT 'Success'
ELSE
BEGIN
	PRINT 'FAIL'
	RETURN
END
------------------------------------------------------------------
PRINT 'Test the director has been accepted'

IF 
	(
			select count(1) from dbo.WorkPeriod wp
			where wp.EmployeeId = @EmployeeId and wp.EffectiveFrom = @EffectiveFrom and wp.EffectiveTo IS NULL
	) = 1
	PRINT 'Success'
ELSE
BEGIN
	PRINT 'FAIL'
	RETURN
END
------------------------------------------------------------------
PRINT 'Test the same employee can''t be added twice'
BEGIN TRY
	exec dbo.AddEmployee 'Donald', 'Trump', @PositionId, @ProjectId, default, 10000
	PRINT 'FAIL'
	RETURN
END TRY
BEGIN CATCH
	PRINT 'Success'
END CATCH
------------------------------------------------------------------
PRINT 'Test adding a subordinate'
SELECT @PositionId = PositionId from dbo.Position where PositionName='Project Manager'
SELECT @ProjectId = ProjectId from dbo.Project where ProjectName='Project A'
BEGIN TRY
	exec dbo.AddEmployee 'Mickey', 'Mouse', @PositionId, @ProjectId, @EmployeeId, 5000, @EffectiveFrom, @EmployeeId OUT
	PRINT 'Success'
END TRY
BEGIN CATCH
	PRINT 'FAIL'
	RETURN
END CATCH
------------------------------------------------------------------
PRINT 'Test the subordinate has a superior'
IF	(
		select count(1) from dbo.Employee where EmployeeId = @EmployeeId and SuperiorId=1
	) = 1
	PRINT 'Success'
ELSE
BEGIN
	PRINT 'FAIL'
	RETURN
END





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

