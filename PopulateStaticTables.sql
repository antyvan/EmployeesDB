USE [EmployeesDB];
GO

SET NOCOUNT ON;

DELETE FROM [dbo].[Position]
INSERT INTO [dbo].[Position] (PositionName) VALUES
('Software Developer'),
('QA Test Engineer'),
('Business Analyst'),
('Project Manager'),
('Chief Executive Officer')

DELETE FROM [dbo].[Project]
INSERT INTO [dbo].[Project] (ProjectName) VALUES
('Project A'),
('Project B'),
('Company Management')

GO