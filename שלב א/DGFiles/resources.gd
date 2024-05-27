
[General]
Version=1

[Preferences]
Username=
Password=2772
Database=
DateFormat=
CommitCount=0
CommitDelay=0
InitScript=

[Table]
Owner=SYS
Name=RESOURCES
Count=500

[Record]
Name=RESOURCEID
Type=NUMBER
Size=
Data=Random(1, 1000000)
Master=

[Record]
Name=RESOURCENAME
Type=VARCHAR2
Size=20
Data=List('plane', 'ship', 'cannon', 'tank', 'rifle', 'gun')
Master=

[Record]
Name=QUANTITY
Type=NUMBER
Size=
Data=Random(0, 20000)
Master=

[Record]
Name=RESOURCESTYPE
Type=VARCHAR2
Size=10
Data=List('high level', 'medium level', 'low level')
Master=

[Record]
Name=UNITID
Type=NUMBER
Size=
Data=List(select unitID from Unit)
Master=

