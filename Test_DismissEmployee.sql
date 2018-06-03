USE [EmployeesDB];
GO
SET NOCOUNT ON;
BEGIN TRY

	BEGIN TRAN;

		TRUNCATE TABLE dbo.EmployeePosition
		TRUNCATE TABLE dbo.EmployeeProject
		TRUNCATE TABLE dbo.Salary
		TRUNCATE TABLE dbo.WorkPeriod
		DELETE dbo.Employee WHERE SuperiorId IS NOT NULL
		DELETE dbo.Employee WHERE SuperiorId IS NULL

		DECLARE @SuperiorPositionId INT,
				@SuperiorProjectId INT,
				@SuperiorId INT

		SELECT @SuperiorPositionId = PositionId from dbo.Position where PositionName='Chief Executive Officer'
		SELECT @SuperiorProjectId = ProjectId from dbo.Project where ProjectName='Company Management'
		EXEC dbo.AddEmployee 'Donald', 'Trump', @SuperiorPositionId, @SuperiorProjectId, default, 10000, default, @SuperiorId OUT

		PRINT 'Test dismissal'
		EXEC [dbo].[DismissEmployee] @EmployeeId = @SuperiorId
		IF NOT EXISTS(select 1 from dbo.Employee emp
					join dbo.WorkPeriod wp on emp.EmployeeId = wp.EmployeeId
					where emp.EmployeeId=@SuperiorId and wp.EffectiveTo is NULL)
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
