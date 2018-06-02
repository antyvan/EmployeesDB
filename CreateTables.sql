USE [EmployeesDB];
GO

-- Remove objects first
IF OBJECT_ID('EmployeesDB.dbo.EmployeeProject') is not null
BEGIN
	DROP TABLE [dbo].[EmployeeProject]
END

IF OBJECT_ID('EmployeesDB.dbo.Project') is not null
BEGIN
	DROP TABLE [dbo].[Project]
END

IF OBJECT_ID('EmployeesDB.dbo.EmployeePosition') is not null
BEGIN
	DROP TABLE [dbo].[EmployeePosition]
END

IF OBJECT_ID('EmployeesDB.dbo.Position') is not null
BEGIN
	DROP TABLE [dbo].[Position]
END

IF OBJECT_ID('EmployeesDB.dbo.Salary') is not null
BEGIN
	DROP TABLE [dbo].[Salary]
END

IF OBJECT_ID('EmployeesDB.dbo.WorkPeriod') is not null
BEGIN
	DROP TABLE [dbo].[WorkPeriod]
END

IF OBJECT_ID('EmployeesDB.dbo.Employee') is not null
BEGIN
	DROP TABLE [dbo].[Employee]
END

GO

--************************************** [dbo].[Employee]

CREATE TABLE [dbo].[Employee]
(
 [EmployeeId] INT IDENTITY(1,1) PRIMARY KEY,
 [FirstName]  VARCHAR(40) NOT NULL,
 [LastName]   VARCHAR(40) NOT NULL,
 [SuperiorId] INT NULL FOREIGN KEY REFERENCES [dbo].[Employee](EmployeeId)
 CONSTRAINT UC_Employee_FLName UNIQUE (FirstName, LastName)
);

GO

--************************************** [dbo].[Project]

CREATE TABLE [dbo].[Project]
(
 [ProjectId] INT IDENTITY(1,1) PRIMARY KEY,
 [ProjectName] VARCHAR(40) NOT NULL
);

GO

--************************************** [dbo].[EmployeeProject]

CREATE TABLE [dbo].[EmployeeProject]
(
 [EmployeeId]    INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Employee](EmployeeId),
 [ProjectId]     INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Project](ProjectId),
 [EffectiveFrom] DATE NOT NULL,
 [EffectiveTo]   DATE NULL
);

GO

--************************************** [dbo].[Position]

CREATE TABLE [dbo].[Position]
(
 [PositionId] INT IDENTITY(1,1) PRIMARY KEY,
 [PositionName] VARCHAR(40) NOT NULL
);

GO

--************************************** [dbo].[EmployeePosition]

CREATE TABLE [dbo].[EmployeePosition]
(
 [EmployeeId]    INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Employee](EmployeeId),
 [PositionId]    INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Position](PositionId),
 [EffectiveFrom] DATE NOT NULL,
 [EffectiveTo]   DATE NULL
);

GO

--************************************** [dbo].[Salary]

CREATE TABLE [dbo].[Salary]
(
 [EmployeeId]    INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Employee](EmployeeId),
 [MonthlyPay]    MONEY NOT NULL,
 [EffectiveFrom] DATE NOT NULL,
 [EffectiveTo]   DATE NULL
);

GO

--************************************** [dbo].[WorkPeriod]

CREATE TABLE [dbo].[WorkPeriod]
(
 [EmployeeId]    INT NOT NULL FOREIGN KEY REFERENCES [dbo].[Employee](EmployeeId),
 [EffectiveFrom] DATE NOT NULL,
 [EffectiveTo]   DATE NULL
);

GO
