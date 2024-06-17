-- select 1
SELECT p.projectName, p.beginDate, p.endDate, COUNT(ip.personID) AS total_people
FROM Projects p
LEFT JOIN inProject ip ON p.projectID = ip.projectID
GROUP BY p.projectID, p.projectName, p.beginDate, p.endDate
ORDER BY p.endDate DESC;


-- select 2
SELECT p.personName, p.personRole, COUNT(ip.projectID) AS project_count
FROM Person p
JOIN inProject ip ON p.personID = ip.personID
GROUP BY p.personID, p.personName, p.personRole
HAVING COUNT(ip.projectID) > 1;

-- select 3
SELECT p.projectName, 
       EXTRACT(YEAR FROM p.beginDate) AS start_year, 
       EXTRACT(YEAR FROM p.endDate) AS end_year,
       SUM(CASE WHEN t.status = 'new' THEN 1 ELSE 0 END) AS new_tasks,
       SUM(CASE WHEN t.status = 'start' THEN 1 ELSE 0 END) AS start_tasks,
       SUM(CASE WHEN t.status = 'middle' THEN 1 ELSE 0 END) AS middle_tasks,
       SUM(CASE WHEN t.status = 'end' THEN 1 ELSE 0 END) AS end_tasks
FROM Projects p
LEFT JOIN Task t ON p.projectID = t.projectID
GROUP BY p.projectID, p.projectName, EXTRACT(YEAR FROM p.beginDate), EXTRACT(YEAR FROM p.endDate);

-- select 4
SELECT u.unitName, COUNT(DISTINCT r.resourceID) AS total_resources, 
    COUNT(DISTINCT p.personID) AS total_people
FROM Unit u
LEFT JOIN Resources r ON u.unitID = r.unitID
LEFT JOIN Person p ON u.unitID = p.unitID
JOIN Excellence e ON u.unitID = e.unitID AND e.excellenceYear < 2000
GROUP BY u.unitID, u.unitName;



-- delete 1
DELETE FROM Task
WHERE status = 'end' AND endDate < TO_DATE('2023-01-01', 'YYYY-MM-DD');

-- delete 2
DELETE FROM Projects p
WHERE p.projectID NOT IN (
    SELECT DISTINCT t.projectID
    FROM Task t
)
AND p.projectID NOT IN (
    SELECT DISTINCT ip.projectID
    FROM inProject ip
);


-- update 1
UPDATE Task
SET status = 'middle'
WHERE endDate BETWEEN TO_DATE('2023-06-01', 'YYYY-MM-DD') AND TO_DATE('2023-08-31', 'YYYY-MM-DD');

-- update 2
UPDATE Projects pr
SET pr.budget = pr.budget * 1.1
WHERE pr.status = 'start' AND EXTRACT(YEAR FROM pr.beginDate) = EXTRACT(YEAR FROM SYSDATE);
