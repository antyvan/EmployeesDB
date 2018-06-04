USE [EmployeesDB];
GO

IF OBJECT_ID('[dbo].[DismissEmployee]', 'P') IS NOT NULL
BEGIN
	DROP PROCEDURE [dbo].[DismissEmployee]
END

GO

CREATE PROCEDURE [dbo].[DismissEmployee]
	@EmployeeId INT,
	@EffectiveTo DATE = NULL -- Use current date if it's null

AS
SET NOCOUNT ON; -- Don't report the number of processed row to client
SET XACT_ABORT ON; -- Enable transaction aborting on constraint failure

IF @EffectiveTo IS NULL
BEGIN
	SET @EffectiveTo = GETDATE()
END

BEGIN TRY

	--Use transactions to guarantee atomic update
	BEGIN TRAN

	IF @EmployeeId IS NULL
		RAISERROR('@EmployeeId can''t be NULL', 11, 1)

	-- Close the current position
	UPDATE dbo.EmployeePosition SET EffectiveTo = @EffectiveTo
	WHERE EmployeeId = @EmployeeId AND EffectiveTo IS NULL

	-- Close the current project
	UPDATE dbo.EmployeeProject SET EffectiveTo = @EffectiveTo
	WHERE EmployeeId = @EmployeeId AND EffectiveTo IS NULL

	-- Close the current salary
	UPDATE dbo.Salary SET EffectiveTo = @EffectiveTo
	WHERE EmployeeId = @EmployeeId AND EffectiveTo IS NULL

	-- Close the current work period
	UPDATE dbo.Employee SET EffectiveTo = @EffectiveTo
	WHERE EmployeeId = @EmployeeId AND EffectiveTo IS NULL				

	COMMIT TRAN

END TRY
BEGIN CATCH

	IF (XACT_STATE()) = -1
		ROLLBACK;

	THROW;
END CATCH
GO