
[General]
Version=1

[Preferences]
Username=
Password=2114
Database=
DateFormat=
CommitCount=0
CommitDelay=0
InitScript=

[Table]
Owner=SYS
Name=PERSON
Count=10..20

[Record]
Name=PERSONID
Type=NUMBER
Size=
Data=Random(200000000, 399999999)
Master=

[Record]
Name=PERSONNAME
Type=VARCHAR2
Size=20
Data=FirstName + LastName
Master=

[Record]
Name=PERSONROLE
Type=VARCHAR2
Size=20
Data=List('Secretary', 'Commander', 'Assistant', 'Cleaner', 'Soldier')
Master=

[Record]
Name=PERSONRANK
Type=VARCHAR2
Size=20
Data=List('corporal', 'sergeant', 'captain', 'major', 'major general', 'general')
Master=

[Record]
Name=UNITID
Type=NUMBER
Size=
Data=List(select unitID from Unit)
Master=

