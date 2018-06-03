USE [EmployeesDB];
GO

IF OBJECT_ID('[dbo].[UpdateEmployeeSuperior]', 'P') IS NOT NULL
BEGIN
	DROP PROCEDURE [dbo].[UpdateEmployeeSuperior]
END

GO

CREATE PROCEDURE [dbo].[UpdateEmployeeSuperior]
	@EmployeeId INT,
	@SuperiorId INT
AS
SET NOCOUNT ON; -- Don't report the number of processed row to client

IF @EmployeeId IS NULL
	RAISERROR('@EmployeeId can''t be NULL', 11, 1)

IF (ISNULL(@SuperiorId, 0) != ISNULL((SELECT SuperiorId FROM dbo.Employee WHERE EmployeeId = @EmployeeId), 0))
	UPDATE dbo.Employee SET SuperiorId = @SuperiorId WHERE EmployeeId = @EmployeeId

GO