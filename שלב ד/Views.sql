--Views

-- Our view
DROP VIEW ProjectResourceAllocation;
CREATE VIEW ProjectResourceAllocation AS
SELECT 
    p.projectID AS ProjectCode,
    p.projectName AS ProjectTitle,
    p.beginDate AS ProjectStartDate,
    p.endDate AS ProjectEndDate,
    p.status AS ProjectStatus,
    per.personID AS TeamMemberID,
    per.personName AS TeamMemberName,
    s.personRole AS TeamMemberRole,
    s.personRank AS TeamMemberRank,
    org.orgID AS UnitCode,
    org.orgName AS UnitName,
    r.resourceID AS ResourceCode,
    r.resourceName AS ResourceName,
    r.quantity AS ResourceQuantity,
    r.resourcesType AS ResourceCategory,
    t.taskID AS TaskCode,
    t.beginDate AS TaskStartDate,
    t.endDate AS TaskEndDate,
    t.status AS TaskStatus
FROM 
    Projects p
JOIN inProject ip ON p.projectID = ip.projectID
JOIN Person per ON ip.personID = per.personID
JOIN Soldier s ON per.personID = s.personID
JOIN Organizations org ON per.orgID = org.orgID
LEFT JOIN Resources r ON org.orgID = r.unitID
LEFT JOIN Task t ON p.projectID = t.projectID
WHERE 
    org.orgType = 'Military';
    
    
-- Other view
DROP VIEW TerroristActivityTracker;
CREATE VIEW TerroristActivityTracker AS
SELECT 
    p.personID AS SuspectID,
    p.personName AS SuspectName,
    p.Birth_Day AS SuspectBirthDate,
    o.orgName AS Terror_Organization,
    t_o.Leader AS OrgLeaderID,
    i.Event_Time AS IncidentDateTime,
    i.Location AS IncidentLocation,
    h.License_plate AS SuspectVehiclePlate,
    v.Color AS SuspectVehicleColor,
    v.Car_Company AS SuspectVehicleMake,
    ph.Phone_Number AS SuspectPhoneNumber,
    a.Arrest_Date AS LastArrestDate,
    a.Investigator_Name AS ArrestingOfficer
FROM 
    Person p
JOIN Terror_Organization t_o ON p.personID = t_o.personID
JOIN Organizations o ON t_o.orgID = o.orgID
LEFT JOIN Incrimination i ON p.personID = i.personID
LEFT JOIN Hold h ON p.personID = h.personID
LEFT JOIN vehicle v ON h.License_plate = v.License_plate
LEFT JOIN Phone ph ON p.personID = ph.personID
LEFT JOIN Arrest a ON p.personID = a.personID
WHERE 
    o.orgType = 'Terror';


-------------------------------------------------------------------------------------------------------------------

-- Select

-- Select for view 1
SELECT * FROM ProjectResourceAllocation
WHERE ROWNUM <= 10;

-- Select for view 2
SELECT * FROM TerroristActivityTracker
WHERE ROWNUM <= 10;
    
----------------------------------------------------------------------    
    

-- Queries

-- Query 1 : Our      
SELECT DISTINCT ProjectTitle, TeamMemberName, TeamMemberRole, TeamMemberRank
FROM ProjectResourceAllocation
WHERE ProjectCode = 1 or ProjectStatus = 'start'
ORDER BY TeamMemberRank DESC;

-- Query 2 : Our      
SELECT ProjectCode, ProjectTitle, COUNT(DISTINCT TeamMemberID) AS NumberOfTeamMembers
FROM ProjectResourceAllocation
WHERE ProjectTitle = 'Project Alpha' or ProjectStatus = 'start'
GROUP BY ProjectCode, ProjectTitle;



-- Query 1 : Other    
SELECT DISTINCT SuspectName, Terror_Organization, SuspectVehiclePlate, SuspectVehicleColor, SuspectVehicleMake
FROM TerroristActivityTracker
WHERE Terror_Organization = 'Al-Qaeda' or Terror_Organization = 'Hamas'
AND SuspectVehiclePlate IS NOT NULL;

-- Query 2 : Other
SELECT SuspectID, SuspectName, IncidentDateTime, IncidentLocation
FROM TerroristActivityTracker
WHERE IncidentDateTime IS NOT NULL
ORDER BY IncidentDateTime DESC;







