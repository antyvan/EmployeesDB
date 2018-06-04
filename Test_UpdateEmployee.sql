USE [EmployeesDB];
GO
SET NOCOUNT ON;
BEGIN TRY

BEGIN TRAN;

TRUNCATE TABLE dbo.EmployeePosition
TRUNCATE TABLE dbo.EmployeeProject
TRUNCATE TABLE dbo.Salary
DELETE dbo.Employee WHERE SuperiorId IS NOT NULL
DELETE dbo.Employee WHERE SuperiorId IS NULL

DECLARE @SuperiorPositionId INT,
		@SuperiorProjectId INT,
		@SuperiorId INT,
		@SubordinatePositionId INT,
		@SubordinateProjectId INT,
		@SubordinateId INT

SELECT @SuperiorPositionId = PositionId from dbo.Position where PositionName='Chief Executive Officer'
SELECT @SuperiorProjectId = ProjectId from dbo.Project where ProjectName='Company Management'
EXEC dbo.AddEmployee 'Donald', 'Trump', @SuperiorPositionId, @SuperiorProjectId, default, 10000, default, @SuperiorId OUT

SELECT @SubordinatePositionId = PositionId from dbo.Position where PositionName='Project Manager'
SELECT @SubordinateProjectId = ProjectId from dbo.Project where ProjectName='Project A'
EXEC dbo.AddEmployee 'Bill', 'Gates', @SubordinatePositionId, @SubordinateProjectId, @SuperiorId, 5000, default, @SubordinateId OUT


	PRINT 'Test FirstName change'
	EXEC [dbo].[UpdateEmployee] @EmployeeId = @SubordinateId, @FirstName = 'Billy'
	IF EXISTS(select 1 from dbo.Employee where EmployeeId=@SubordinateId and FirstName = 'Billy')
		PRINT 'Success'
	ELSE
		RAISERROR('FAIL', 11, 1)

	PRINT 'Test LastName change'
	EXEC [dbo].[UpdateEmployee] @EmployeeId = @SubordinateId, @LastName = 'Gate'
	IF EXISTS(select 1 from dbo.Employee where EmployeeId=@SubordinateId and LastName = 'Gate')
		PRINT 'Success'
	ELSE
		RAISERROR('FAIL', 11, 1)

	PRINT 'Test PositionId change'
	EXEC [dbo].[UpdateEmployee] @EmployeeId = @SuperiorId, @PositionId = @SubordinatePositionId
	IF (select empPos.PositionId from dbo.Employee emp
				join dbo.EmployeePosition empPos on emp.EmployeeId = empPos.EmployeeId
				where emp.EmployeeId=@SuperiorId and empPos.EffectiveTo is NULL) = @SubordinatePositionId
		PRINT 'Success'
	ELSE
		RAISERROR('FAIL', 11, 1)

	PRINT 'Test ProjectId change'
	EXEC [dbo].[UpdateEmployee] @EmployeeId = @SuperiorId, @ProjectId = @SubordinateProjectId
	IF (select empProj.ProjectId from dbo.Employee emp
				join dbo.EmployeeProject empProj on emp.EmployeeId = empProj.EmployeeId
				where emp.EmployeeId=@SuperiorId and empProj.EffectiveTo is NULL) = @SubordinateProjectId
		PRINT 'Success'
	ELSE
		RAISERROR('FAIL', 11, 1)

	PRINT 'Test MonthlyPay change'
	EXEC [dbo].[UpdateEmployee] @EmployeeId = @SuperiorId, @MonthlyPay = 1000
	IF (select sal.MonthlyPay from dbo.Employee emp
				join dbo.Salary sal on emp.EmployeeId = sal.EmployeeId
				where emp.EmployeeId=@SuperiorId and sal.EffectiveTo is NULL) = 1000
		PRINT 'Success'
	ELSE
		RAISERROR('FAIL', 11, 1)

ROLLBACK TRAN;
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE()

	IF XACT_STATE() != 0
		ROLLBACK TRANSACTION;
	
END CATCH

GO

PRINT 'Test NULL EmployeeId'
BEGIN TRY
	BEGIN TRAN
	EXEC [dbo].[UpdateEmployee] @EmployeeId = NULL
	PRINT 'FAIL'
ROLLBACK TRAN
END TRY
BEGIN CATCH
	PRINT 'Success'

	IF XACT_STATE() != 0
		ROLLBACK TRANSACTION
END CATCH