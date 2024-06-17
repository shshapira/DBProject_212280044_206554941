-- 1
SELECT p.personName, p.personRole, pr.projectName
FROM Person p
JOIN inProject ip ON p.personID = ip.personID
JOIN Projects pr ON ip.projectID = pr.projectID
JOIN Task t ON pr.projectID = t.projectID
JOIN Unit u ON p.unitID = u.unitID
JOIN Resources r ON u.unitID = r.unitID
GROUP BY p.personName, p.personRole, pr.projectName
HAVING COUNT(DISTINCT r.resourceID) > &<name = "amount_of_resources" type ="integer" ifempty="3">;


-- 2
SELECT projectName, beginDate, endDate
FROM Projects
WHERE budget BETWEEN &<name = "min_budget" 
                       type = "integer"
                       default = "2100"> AND &<name = "max_budget"
                                                type = "integer">
ORDER BY projectName;



-- 3
SELECT projectName, beginDate, endDate
FROM Projects p
WHERE p.budget BETWEEN &<name = "min_budget"
                        type = "integer"
                        default = "2100"> AND &<name = "max_budget"
                                                type = "integer">
  AND p.status IN (&<name = "status"
                     type = "string"
                     list = "new, start, middle, end"
                     multiselect = "yes"
                     hint = "pick the wanted status">)
ORDER BY projectName;



-- 4
SELECT p.projectName, p.beginDate, p.endDate, COUNT(ip.personID) AS total_people
FROM Projects p
LEFT JOIN inProject ip ON p.projectID = ip.projectID
Where p.status = &<name ="status"
type="string"
list ="start, middle, end" 
multiselect ="yes" 
hint ="pick the wanted status">
GROUP BY
  p.projectID,
  p.projectName,
  p.beginDate,
  p.endDate
ORDER BY
  p.endDate DESC;
