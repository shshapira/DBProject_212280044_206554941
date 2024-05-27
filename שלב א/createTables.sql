CREATE TABLE Projects
(
  projectID INT NOT NULL,
  projectName VARCHAR2(20) NOT NULL,
  beginDate DATE NOT NULL,
  endDate DATE NOT NULL,
  status VARCHAR2(10) DEFAULT 'new' CHECK (status in ('new', 'start', 'middle', 'end' )),
  budget FLOAT NOT NULL CHECK(budget >= 0),
  PRIMARY KEY (projectID)
);

CREATE TABLE Unit
(
  unitID INT NOT NULL,
  unitLocation VARCHAR2(20) NOT NULL,
  unitName VARCHAR2(20) NOT NULL,
  PRIMARY KEY (unitID)
);

CREATE TABLE Resources
(
  resourceID INT NOT NULL,
  resourceName VARCHAR2(20) NOT NULL,
  quantity INT NOT NULL,
  resourcesType VARCHAR2(10) NOT NULL,
  unitID INT NOT NULL,
  PRIMARY KEY (resourceID),
  FOREIGN KEY (unitID) REFERENCES Unit(unitID)
);

CREATE TABLE Task
(
  taskID INT NOT NULL,
  projectID INT NOT NULL,
  endDate DATE NOT NULL,
  beginDate DATE NOT NULL,
  status VARCHAR2(10) DEFAULT 'new' CHECK (status in ('new', 'start', 'middle', 'end' )),
  PRIMARY KEY (taskID, projectID),
  FOREIGN KEY (projectID) REFERENCES Projects(projectID)
);

CREATE TABLE Excellence
(
  excellenceType VARCHAR2(20) NOT NULL,
  excellenceYear NUMBER(4) NOT NULL,
  have_money CHAR NOT NULL CHECK(have_money in ('T', 'F')),
  unitID INT NOT NULL,
  PRIMARY KEY (excellenceType, excellenceYear),
  FOREIGN KEY (unitID) REFERENCES Unit(unitID)
);

CREATE TABLE Person
(
  personID INT NOT NULL,
  personName VARCHAR2(20) NOT NULL,
  personRole VARCHAR2(20) NOT NULL,
  personRank VARCHAR2(20) NOT NULL,
  unitID INT NOT NULL,
  PRIMARY KEY (personID),
  FOREIGN KEY (unitID) REFERENCES Unit(unitID)
);

CREATE TABLE inProject
(
  projectID INT NOT NULL,
  personID INT NOT NULL,
  PRIMARY KEY (projectID, personID),
  FOREIGN KEY (projectID) REFERENCES Projects(projectID),
  FOREIGN KEY (personID) REFERENCES Person(personID)
);
