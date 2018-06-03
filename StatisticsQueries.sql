USE [EmployeesDB];
GO

-- SELECT BY PROJECT
SELECT
	proj.ProjectName,
	COUNT(empProj.EmployeeId) as PeopleCount,
	SUM(sal.MonthlyPay) as TotalMonthlyPay
FROM dbo.EmployeeProject empProj
	JOIN dbo.Project proj on empProj.ProjectId = proj.ProjectId
	JOIN dbo.Salary sal on empProj.EmployeeId = sal.EmployeeId and sal.EffectiveTo is NULL
	JOIN dbo.WorkPeriod wp on empProj.EmployeeId = wp.EmployeeId
WHERE
	empProj.EffectiveTo is NULL
GROUP BY proj.ProjectName
ORDER BY proj.ProjectName

-- SELECT BY POSITION
SELECT
	pos.PositionName,
	COUNT(empPos.EmployeeId) as PeopleCount,
	SUM(sal.MonthlyPay) as TotalMonthlyPay
FROM dbo.EmployeePosition empPos
	JOIN dbo.Position pos on empPos.PositionId = pos.PositionId
	JOIN dbo.Salary sal on empPos.EmployeeId = sal.EmployeeId and sal.EffectiveTo is NULL
	JOIN dbo.WorkPeriod wp on empPos.EmployeeId = wp.EmployeeId
WHERE
	empPos.EffectiveTo is NULL
GROUP BY pos.PositionName
ORDER BY pos.PositionName

-- SELECT BY SUPERIOR???