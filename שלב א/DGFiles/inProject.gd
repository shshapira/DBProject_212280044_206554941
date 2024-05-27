
[General]
Version=1

[Preferences]
Username=
Password=2855
Database=
DateFormat=
CommitCount=0
CommitDelay=0
InitScript=

[Table]
Owner=SYS
Name=INPROJECT
Count=500

[Record]
Name=PROJECTID
Type=NUMBER
Size=
Data=List(select projectID from Projects)
Master=

[Record]
Name=PERSONID
Type=NUMBER
Size=
Data=List(select personID from Person)
Master=

