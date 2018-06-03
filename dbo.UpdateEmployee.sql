USE [EmployeesDB];
GO

IF OBJECT_ID('[dbo].[UpdateEmployee]', 'P') IS NOT NULL
BEGIN
	DROP PROCEDURE [dbo].[UpdateEmployee]
END

GO

CREATE PROCEDURE [dbo].[UpdateEmployee]
	@EmployeeId INT,
	@FirstName VARCHAR(40) = NULL,
	@LastName VARCHAR(40) = NULL,
	@PositionId INT = NULL,
	@ProjectId INT = NULL,
	@MonthlyPay MONEY = NULL,
	@EffectiveFrom DATE = NULL -- Use current date if it's null. It's expected to be greater than currently used for the active record.
								-- Ideally, I'd test it but I won't do it purposefully to minimize checks

AS
SET NOCOUNT ON; -- Don't report the number of processed row to client
SET XACT_ABORT ON; -- Enable transaction aborting on constraint failure

IF @EffectiveFrom IS NULL
BEGIN
	SET @EffectiveFrom = DATEADD(DAY, 1, GETDATE())
END

BEGIN TRY

	--Use transactions to guarantee atomic update
	BEGIN TRAN

	IF @EmployeeId IS NULL
		RAISERROR('@EmployeeId can''t be NULL', 11, 1)

	IF (@FirstName IS NOT NULL AND @FirstName != (SELECT FirstName FROM dbo.Employee WHERE EmployeeId = @EmployeeId))
		UPDATE dbo.Employee SET FirstName = @FirstName WHERE EmployeeId = @EmployeeId

	IF (@LastName IS NOT NULL AND @LastName != (SELECT LastName FROM dbo.Employee WHERE EmployeeId = @EmployeeId))
		UPDATE dbo.Employee SET LastName = @LastName WHERE EmployeeId = @EmployeeId

	IF (@PositionId IS NOT NULL AND @PositionId != (SELECT PositionId FROM dbo.EmployeePosition WHERE EmployeeId=@EmployeeId AND EffectiveTo IS NULL))
	BEGIN
		-- Close the current position
		UPDATE dbo.EmployeePosition SET EffectiveTo = DATEADD(DAY, -1, @EffectiveFrom)
		WHERE EmployeeId = @EmployeeId AND EffectiveTo IS NULL
		-- Create a new one
		INSERT INTO dbo.EmployeePosition (EmployeeId, PositionId, EffectiveFrom)
		VALUES (@EmployeeId, @PositionId, @EffectiveFrom)
	END

	IF (@ProjectId IS NOT NULL AND @ProjectId != (SELECT ProjectId FROM dbo.EmployeeProject WHERE EmployeeId=@EmployeeId AND EffectiveTo IS NULL))
	BEGIN
		-- Close the current project
		UPDATE dbo.EmployeeProject SET EffectiveTo = DATEADD(DAY, -1, @EffectiveFrom)
		WHERE EmployeeId = @EmployeeId AND EffectiveTo IS NULL
		-- Create a new one
		INSERT INTO dbo.EmployeeProject (EmployeeId, ProjectId, EffectiveFrom)
		VALUES (@EmployeeId, @ProjectId, @EffectiveFrom)
	END

	IF (@MonthlyPay IS NOT NULL AND @MonthlyPay != (SELECT MonthlyPay FROM dbo.Salary WHERE EmployeeId=@EmployeeId AND EffectiveTo IS NULL))
	BEGIN
		-- Close the current salary
		UPDATE dbo.Salary SET EffectiveTo = DATEADD(DAY, -1, @EffectiveFrom)
		WHERE EmployeeId = @EmployeeId AND EffectiveTo IS NULL
		-- Create a new one
		INSERT INTO dbo.Salary (EmployeeId, MonthlyPay, EffectiveFrom)
		VALUES (@EmployeeId, @MonthlyPay, @EffectiveFrom)
	END

	COMMIT TRAN

END TRY
BEGIN CATCH

	IF (XACT_STATE()) = -1
		ROLLBACK;

	THROW;
END CATCH
GO