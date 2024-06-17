-- person - personRank: NOT NULL constraint
ALTER TABLE Person MODIFY personRank VARCHAR2(20) NOT NULL;

-- Resources - resourcesType: CHECK constraint
ALTER TABLE Resources ADD CONSTRAINT resourcesType CHECK (resourcesType IN ('low level', 'medium lev', 'high level'));

-- Projects - status DEFAULT constraint
ALTER TABLE Projects MODIFY status VARCHAR2(10) DEFAULT 'new' NOT NULL;
