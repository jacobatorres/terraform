import pandas as pd
from sodapy import Socrata
import psycopg2



client = Socrata(
		"data.lacity.org",
		"mrFFnLa5TmKNFJexBQnTMqV6M",
		username="jacobangelo_torres@yahoo.com",
		password="!Qm5M@u6e@vWKMD",
		timeout=10
)

results = client.get("e7h6-4a3e", limit=100)
print("here")
results_df = pd.DataFrame.from_records(results)


print(results_df)

try:
    conn = psycopg2.connect(
            host="terraform-20231216234206250800000001.ci2jsqsrxumg.us-east-1.rds.amazonaws.com",
            database="tutorial", 
            user="da_admin",
            password="tutorialpw")
    print("was able to connect")
except Exception as e:
    print("error when connecting")
    print(e)
    exit(1)


# make the table

cur = conn.cursor()
cur.execute("CREATE TABLE IF NOT EXISTS spacestate ( space_id INTEGER NOT NULL, occ_state VARCHAR(40) NOT NULL)")
conn.commit()

print("table made")



# insert data to table

thelist = results_df.values.tolist()
sampledata = [thelist[0][0], thelist[1][2]]

print(sampledata)

for i in range(0, 10):

    sqlforinsert = """INSERT INTO spacestate(space_id, occ_state)  VALUES({idval}, '{occstateval}')""".format(idval = i, occstateval = thelist[i][2])
    print(sqlforinsert)


    cur = conn.cursor()
    cur.execute(sqlforinsert)
    conn.commit()

cur.close()
conn.commit()


print("also inserted data")







