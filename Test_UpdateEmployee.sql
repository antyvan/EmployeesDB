USE [EmployeesDB];
GO

PRINT 'Test FirstName change'
BEGIN TRAN
	DECLARE @EmployeeId INT
	SELECT @EmployeeId = EmployeeId FROM dbo.Employee WHERE FirstName = 'Bill'
	BEGIN TRY
		EXEC [dbo].[UpdateEmployee] @EmployeeId = @EmployeeId, @FirstName = 'Billy'
		PRINT 'Success'
	END TRY
	BEGIN CATCH
		PRINT 'FAIL'
	END CATCH
ROLLBACK TRAN

GO

PRINT 'Test LastName change'
BEGIN TRAN
	DECLARE @EmployeeId INT
	SELECT @EmployeeId = EmployeeId FROM dbo.Employee WHERE LastName = 'Gates'
	BEGIN TRY
		EXEC [dbo].[UpdateEmployee] @EmployeeId = @EmployeeId, @LastName = 'Gate'
		PRINT 'Success'
	END TRY
	BEGIN CATCH
		PRINT 'FAIL'
	END CATCH
ROLLBACK TRAN

GO

PRINT 'Test SuperiorId change'
BEGIN TRAN
	DECLARE @EmployeeId INT
	SELECT @EmployeeId = EmployeeId FROM dbo.Employee WHERE LastName = 'Gates'
	BEGIN TRY
		EXEC [dbo].[UpdateEmployee] @EmployeeId = @EmployeeId, @SuperiorId = 'Gate'
		PRINT 'Success'
	END TRY
	BEGIN CATCH
		PRINT 'FAIL'
	END CATCH
ROLLBACK TRAN

GO

PRINT 'Test NULL EmployeeId'
BEGIN TRY
	EXEC [dbo].[UpdateEmployee] @EmployeeId = NULL
	PRINT 'FAIL'
END TRY
BEGIN CATCH
	PRINT 'Success'
END CATCH

GO

DECLARE @EmployeeId INT
SELECT @EmployeeId = EmployeeId FROM dbo.Employee WHERE FirstName = 'Bill'

PRINT 'Test same FistName'
BEGIN TRY
	EXEC [dbo].[UpdateEmployee] @EmployeeId = @EmployeeId, @FirstName = 'Bill'
	PRINT 'Success'
END TRY
BEGIN CATCH
	PRINT 'FAIL'
END CATCH