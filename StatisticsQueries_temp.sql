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

-- SELECT AN EMPLOYEE HISTORY
DECLARE @EmployeeId INT
SELECT @EmployeeId = EmployeeId from dbo.Employee WHERE FirstName= 'Donald' and LastName ='Duck'

SELECT
	sproj.ProjectName,
	spos.PositionName,
	sal.MonthlyPay,
	(SELECT MAX(v) FROM (VALUES (proj.EffectiveFrom), (pos.EffectiveFrom)) AS value(v)) as EffectiveFrom,
	(SELECT MIN(v) FROM (VALUES (ISNULL(proj.EffectiveTo, '31 Dec 9999')), (ISNULL(pos.EffectiveTo, '31 Dec 9999'))) AS VALUE(v)) as EffectiveTo

FROM dbo.Employee emp
JOIN dbo.EmployeeProject proj ON emp.EmployeeId = proj.EmployeeId
JOIN dbo.EmployeePosition pos ON emp.EmployeeId = pos.EmployeeId
	AND (
		(ISNULL(proj.EffectiveTo, pos.EffectiveTo) IS NULL)
		OR (proj.EffectiveTo IS NULL AND pos.EffectiveTo >= proj.EffectiveFrom)
		OR (pos.EffectiveTo IS NULL AND proj.EffectiveTo >= pos.EffectiveFrom)
		OR (NOT(proj.EffectiveFrom > pos.EffectiveTo OR pos.EffectiveFrom > proj.EffectiveTo))
	)
JOIN dbo.Salary sal on emp.EmployeeId = sal.EmployeeId
	AND (
		(ISNULL(proj.EffectiveTo, sal.EffectiveTo) IS NULL)
		OR (proj.EffectiveTo IS NULL AND sal.EffectiveTo >= proj.EffectiveFrom)
		OR (sal.EffectiveTo IS NULL AND proj.EffectiveTo >= sal.EffectiveFrom)
		OR (NOT(proj.EffectiveFrom > sal.EffectiveTo OR sal.EffectiveFrom > proj.EffectiveTo))
	)

JOIN dbo.Project sproj ON proj.ProjectId = sproj.ProjectId
JOIN dbo.Position spos ON pos.PositionId = spos.PositionId
WHERE emp.EmployeeId = @EmployeeId

SELECT MAX(v)
FROM (VALUES (1),(2)) AS VALUE(v);


--------------
DECLARE @EmployeeId INT
SELECT @EmployeeId = EmployeeId from dbo.Employee WHERE FirstName= 'Donald' and LastName ='Duck'

--;WITH cte_AllPeriods (PeriodMark, PeriodDate)
--AS
--(
--	SELECT PeriodMark, PeriodDate
--	FROM
--	(
--		SELECT
--			proj.EffectiveFrom,
--			proj.EffectiveTo
--		FROM dbo.EmployeeProject proj
--		WHERE proj.EmployeeId = @EmployeeId
--	) as a UNPIVOT (PeriodDate FOR PeriodMark IN (EffectiveFrom, EffectiveTo)) as unpvt

--	UNION
	
--	SELECT PeriodMark, PeriodDate
--	FROM
--	(
--		SELECT
--			pos.EffectiveFrom,
--			pos.EffectiveTo
--		FROM dbo.EmployeePosition pos
--		WHERE pos.EmployeeId = @EmployeeId
--	) as a UNPIVOT (PeriodDate FOR PeriodMark IN (EffectiveFrom, EffectiveTo)) as unpvt

--	UNION
	
--	SELECT PeriodMark, PeriodDate
--	FROM
--	(
--		SELECT
--			sal.EffectiveFrom,
--			sal.EffectiveTo
--		FROM dbo.Salary sal
--		WHERE sal.EmployeeId = @EmployeeId
--	) as a UNPIVOT (PeriodDate FOR PeriodMark IN (EffectiveFrom, EffectiveTo)) as unpvt
--)
--select [EffectiveFrom], [EffectiveTo]
--from
--(
--	select PeriodMark, PeriodDate from cte_AllPeriods order by PeriodDate
--) as source
--PIVOT
--(	COUNT(PeriodDate)
--	FOR 
--)



SELECT
	sproj.ProjectName,
	proj.EffectiveFrom,
	proj.EffectiveTo
FROM dbo.EmployeeProject proj
JOIN dbo.Project sproj ON proj.ProjectId = sproj.ProjectId
WHERE proj.EmployeeId = @EmployeeId

SELECT
	spos.PositionName,
	pos.EffectiveFrom,
	pos.EffectiveTo
FROM dbo.EmployeePosition pos
JOIN dbo.Position spos ON pos.PositionId = spos.PositionId
WHERE pos.EmployeeId = @EmployeeId

SELECT
	sal.MonthlyPay,
	sal.EffectiveFrom,
	sal.EffectiveTo
FROM dbo.Salary sal
WHERE sal.EmployeeId = @EmployeeId