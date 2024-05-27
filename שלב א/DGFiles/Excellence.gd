
[General]
Version=1

[Preferences]
Username=
Password=2134
Database=
DateFormat=
CommitCount=0
CommitDelay=0
InitScript=

[Table]
Owner=SYS
Name=EXCELLENCE
Count=500

[Record]
Name=EXCELLENCETYPE
Type=VARCHAR2
Size=20
Data=List('Chief of Staff', 'Corps commander', 'Prime Minister')
Master=

[Record]
Name=EXCELLENCEYEAR
Type=NUMBER
Size=4
Data=Random(1900, 2100)
Master=

[Record]
Name=HAVE_MONEY
Type=CHAR
Size=1
Data=List('T', 'F')
Master=

[Record]
Name=UNITID
Type=NUMBER
Size=
Data=List(select unitID from Unit)
Master=

