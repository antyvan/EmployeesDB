USE [EmployeesDB];
GO

IF OBJECT_ID('[dbo].[AddEmployee]', 'P') IS NOT NULL
BEGIN
	DROP PROCEDURE [dbo].[AddEmployee]
END

GO

CREATE PROCEDURE [dbo].[AddEmployee]
	@FirstName VARCHAR(40),
	@LastName VARCHAR(40),
	@PositionId INT,
	@ProjectId INT,
	@SuperiorId INT = NULL, 
	@MonthlyPay MONEY,
	@EffectiveFrom DATE = NULL, -- Use current date if it's null
	@EmployeeId INT = NULL OUT

AS
SET NOCOUNT ON; -- Don't report the number of processed row to client
SET XACT_ABORT ON; -- Enable transaction aborting on constraint failure

IF @EffectiveFrom IS NULL
BEGIN
	SET @EffectiveFrom = GETDATE()
END

BEGIN TRY 
	--Use transactions to guarantee atomic insertion
	BEGIN TRAN

		INSERT INTO dbo.Employee (FirstName, LastName, SuperiorId, EffectiveFrom)
		VALUES (@FirstName, @LastName, @SuperiorId, @EffectiveFrom)

		SET @EmployeeId = @@IDENTITY

		--NB. Error should be reported if the position id is invalid
		INSERT INTO dbo.EmployeePosition (EmployeeId, PositionId, EffectiveFrom)
		VALUES (@EmployeeId, @PositionId, @EffectiveFrom)

		--NB. Error should be reported if the project id is invalid
		INSERT INTO dbo.EmployeeProject(EmployeeId, ProjectId, EffectiveFrom)
		VALUES (@EmployeeId, @ProjectId, @EffectiveFrom)

		INSERT INTO dbo.Salary(EmployeeId, MonthlyPay, EffectiveFrom)
		VALUES (@EmployeeId, @MonthlyPay, @EffectiveFrom)

	COMMIT TRAN
END TRY
BEGIN CATCH

	IF (XACT_STATE()) = -1
		ROLLBACK;

	THROW;
END CATCH
GO