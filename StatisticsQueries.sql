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
	JOIN dbo.WorkPeriod wp on empProj.EmployeeId = wp.EmployeeId and wp.EffectiveTo is NULL
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
	JOIN dbo.WorkPeriod wp on empPos.EmployeeId = wp.EmployeeId and wp.EffectiveTo is NULL
WHERE
	empPos.EffectiveTo is NULL
GROUP BY pos.PositionName
ORDER BY pos.PositionName

-- SELECT BY SUPERIORS
SELECT
	empSup.FirstName,
	empSup.LastName,
	COUNT(empSub.EmployeeId) as SubordinateCount,
	SUM(sal.MonthlyPay) as TotalMonthlyPay
FROM dbo.Employee empSup
	JOIN dbo.WorkPeriod wpSup on empSup.EmployeeId = wpSup.EmployeeId and wpSup.EffectiveTo is NULL
	JOIN dbo.Employee empSub on empSup.EmployeeId = empSub.SuperiorId
	JOIN dbo.Salary sal on empSub.EmployeeId = sal.EmployeeId and sal.EffectiveTo is NULL
	JOIN dbo.WorkPeriod wpSub on empSub.EmployeeId = wpSub.EmployeeId and wpSub.EffectiveTo is NULL
GROUP BY empSup.FirstName, empSup.LastName
ORDER BY empSup.FirstName, empSup.LastName

-- SELECT GRAND TOTAL BY A SUPERIOR
DECLARE @SuperiorId INT
SELECT @SuperiorId = EmployeeId from dbo.Employee WHERE FirstName= 'Donald' and LastName ='Trump'

;WITH cte_Subordinates (EmployeeId)
AS
(
	SELECT @SuperiorId
	UNION ALL
	SELECT emp.EmployeeId
	FROM cte_Subordinates sub
	JOIN dbo.Employee emp ON sub.EmployeeId = emp.SuperiorId
)
SELECT
	COUNT(sub.EmployeeId) as SubordinateCount,
	ISNULL(SUM(sal.MonthlyPay), 0) as TotalMonthlyPay
FROM cte_Subordinates sub
	JOIN dbo.Salary sal on sub.EmployeeId = sal.EmployeeId and sal.EffectiveTo is NULL
	JOIN dbo.WorkPeriod wp on sub.EmployeeId = wp.EmployeeId and wp.EffectiveTo is NULL
WHERE sub.EmployeeId != @SuperiorId

-- Possible improvement: SELECT AN EMPLOYEE HISTORY