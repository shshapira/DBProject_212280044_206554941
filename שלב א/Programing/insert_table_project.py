from builtins import range
import random
from faker import Faker

fake = Faker()
sqlSqript = ""

for i in range(500):
    projectId = i
    projectName = fake.name()
    while(len(projectName) > 19):
        projectName = fake.name()
    beginDate = fake.date_between(start_date='-10y', end_date='today')
    endDate = fake.date_between(start_date='today', end_date='+10y')
    status = random.choice(["new", "start", "middle", "end"])
    budget = fake.random_int(100, 10000000)
    sqlSqript += f"""
        INSERT INTO Projects (projectId, projectName, beginDate, endDate, status, budget)
        VALUES ({projectId}, '{projectName}', TO_DATE('{beginDate}', 'YYYY-MM-DD'), TO_DATE('{endDate}', 'YYYY-MM-DD'), '{status}', {budget});
        """ + "\n"

with open("insetTables.sql", 'w') as file:
    file.write(sqlSqript)