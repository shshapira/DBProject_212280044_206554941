-- 1. Create new Organizations table
CREATE TABLE Organizations (
    orgID INT PRIMARY KEY,
    orgName VARCHAR2(60),
    orgType VARCHAR2(20)
);

-- 2. Transfer data from Terror_Organization
INSERT INTO Organizations (orgID, orgName, orgType)
SELECT ROWNUM + 1000, Organization_Name, 'Terror'
FROM Terror_Organization;

-- 3. Transfer data from Unit
INSERT INTO Organizations (orgID, orgName, orgType)
SELECT unitID, unitName, 'Military'
FROM Unit;

-- 4. Update Terror_Organization
ALTER TABLE Terror_Organization ADD orgID INT;
UPDATE Terror_Organization t
SET t.orgID = (SELECT o.orgID FROM Organizations o WHERE o.orgName = t.Organization_Name);
ALTER TABLE Terror_Organization DROP COLUMN Organization_Name;
ALTER TABLE Terror_Organization DROP COLUMN Foundation_Year;
ALTER TABLE Terror_Organization RENAME COLUMN Id TO personID;
ALTER TABLE Terror_Organization ADD CONSTRAINT fk_terrorOrg_Organizations FOREIGN KEY (orgID) REFERENCES organizations(orgID);

-- 5. Update Unit
ALTER TABLE Unit RENAME COLUMN unitID TO orgID;
ALTER TABLE Unit DROP COLUMN unitName;


ALTER TABLE Person RENAME TO Soldier;
ALTER TABLE Humen RENAME TO Prison;


CREATE TABLE Person (
    personID INT PRIMARY KEY,
    personName VARCHAR2(60),
    Birth_Day DATE,
    Gender VARCHAR2(1),
    orgID INT
);

-- Transfer data from Person (original) to new Person table
INSERT INTO Person (personID, personName, Birth_Day, Gender, orgID)
SELECT personID, personName, NULL, NULL, unitID
FROM Soldier;

-- Transfer data from Humen to Person
INSERT INTO Person (personID, personName, Birth_Day, Gender, orgID)
SELECT Id, First_Name || ' ' || Last_Name, Birth_Day, Gender, NULL
FROM Prison;

-- Update orgID for persons from Humen
UPDATE Person p
SET p.orgID = (
    SELECT t.orgID
    FROM Terror_Organization t
    WHERE t.Leader = p.personName
)
WHERE p.personID IN (SELECT Id FROM Prison);

-- Update Soldier table
ALTER TABLE Soldier DROP COLUMN personName;
ALTER TABLE Soldier ADD CONSTRAINT fk_soldier_person FOREIGN KEY (personID) REFERENCES Person(personID);

-- Update Prison table
ALTER TABLE Prison DROP COLUMN First_Name;
ALTER TABLE Prison DROP COLUMN Last_Name;
ALTER TABLE Prison DROP COLUMN Birth_Day;
ALTER TABLE Prison DROP COLUMN Gender;
ALTER TABLE Prison RENAME COLUMN Id TO personID;
ALTER TABLE Prison ADD CONSTRAINT fk_prison_person FOREIGN KEY (personID) REFERENCES Person(personID);

-- Update other tables to reference Person instead of Humen
ALTER TABLE Hold RENAME COLUMN Id TO personID;
ALTER TABLE Hold ADD CONSTRAINT fk_hold_person FOREIGN KEY (personID) REFERENCES Person(personID);

ALTER TABLE Phone RENAME COLUMN Id TO personID;
ALTER TABLE Phone ADD CONSTRAINT fk_phone_person FOREIGN KEY (personID) REFERENCES Person(personID);

ALTER TABLE Incrimination RENAME COLUMN Id TO personID;
ALTER TABLE Incrimination ADD CONSTRAINT fk_incrimination_person FOREIGN KEY (personID) REFERENCES Person(personID);

ALTER TABLE Weapon RENAME COLUMN Id TO personID;
ALTER TABLE Weapon ADD CONSTRAINT fk_weapon_person FOREIGN KEY (personID) REFERENCES Person(personID);

ALTER TABLE Arrest RENAME COLUMN Id TO personID;
ALTER TABLE Arrest ADD CONSTRAINT fk_arrest_person FOREIGN KEY (personID) REFERENCES Person(personID);

ALTER TABLE Live_In RENAME COLUMN Id TO personID;
ALTER TABLE Live_In ADD CONSTRAINT fk_live_in_person FOREIGN KEY (personID) REFERENCES Person(personID);

-- Add foreign key from Person to Organizations
ALTER TABLE Person ADD CONSTRAINT fk_person_organization FOREIGN KEY (orgID) REFERENCES Organizations(orgID);
