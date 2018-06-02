USE [EmployeesDB];
GO

CREATE PROCEDURE [dbo].[AddEmployee]
	@FirstName VARCHAR(40),
	@LastName VARCHAR(40),
	@PositionId INT,
	@ProjectId INT,
	@SuperiorId INT NULL, 
	@MonthlyPay MONEY,
	@EffectiveFrom DATE

AS
	SET NOCOUNT ON 
	
	DECLARE @EmployeeId INT

	--Use transactions to guarantee atomic insertion
	BEGIN TRAN

	--Report an error if an attempt is made to insert an existing person

	INSERT INTO dbo.Employee (FirstName, LastName, SuperiorId)
	VALUES (@FirstName, @LastName)

	SET @EmployeeId = @@IDENTITY

	-- Error should be reported if the position id is invalid
	INSERT INTO dbo.EmployeePosition (EmployeeId, PositionId, EffectiveFrom)
	VALUES (@EmployeeId, @PositionId, @EffectiveFrom)

	-- Error should be reported if the project id is invalid
	INSERT INTO dbo.EmployeeProject(EmployeeId, ProjectId, EffectiveFrom)
	VALUES (@EmployeeId, @ProjectId, @EffectiveFrom)

	INSERT INTO dbo.Salary(EmployeeId, MonthlyPay, EffectiveFrom)
	VALUES (@EmployeeId, @MonthlyPay, @EffectiveFrom)

	INSERT INTO dbo.WorkPeriod(EmployeeId, EffectiveFrom)
	VALUES (@EmployeeId, @EffectiveFrom)

	COMMIT
