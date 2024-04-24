import boto3
from sodapy import Socrata
import pandas as pd
import psycopg2
from botocore.exceptions import ClientError

from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime, timedelta

data_code_dictionary = {

    "business": ["6rrh-rzua", ["location_account", "naics", "primary_naics_description", "location"]],

    "parking_spot_loc": ["s49e-q6j2", ["spaceid", "latlng"]],

    "parking_spot_archived": ["cj8s-ivry", ["SpaceID", "EventTime_Local", "EventTime_UTC", "OccupancyState"]], # will scrape separately

    "parking_spot_realtime": ["e7h6-4a3e", ["spaceid", "eventtime", "occupancystate"]],

    "crime": ["amvf-fr72", ["rpt_id", "lat", "lon", "arst_date"]]

}

def run_sql(conn, sql_to_run, params = ()):
    try:
        cur = conn.cursor()
        cur.execute(sql_to_run, params)
        conn.commit()
    except Exception as e:
        print("Error when running the sql: {}".format(e))
        conn.rollback()
        return e



def get_secret(secret_name, region):
    print("Getting secret {} from {}".format(secret_name, region))

    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region,
    )


    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
        print("im here")
    except ClientError as e:
        print("ClientError")
        print(e)

        if e.response['Error']['Code'] == 'ResourceNotFoundException':
            print("The requested secret " + secret_name + " was not found")
        elif e.response['Error']['Code'] == 'InvalidRequestException':
            print("The request was invalid due to:", e)
        elif e.response['Error']['Code'] == 'InvalidParameterException':
            print("The request had invalid params:", e)
        elif e.response['Error']['Code'] == 'DecryptionFailure':
            print("The requested secret can't be decrypted using the provided KMS key:", e)
        elif e.response['Error']['Code'] == 'InternalServiceError':
            print("An error occurred on service side:", e)
    else:
        # Secrets Manager decrypts the secret value using the associated KMS CMK
        # Depending on whether the secret was a string or binary, only one of these fields will be populated
        print("ok else")
        print(get_secret_value_response)
        if 'SecretString' in get_secret_value_response:
            text_secret_data = get_secret_value_response['SecretString']
        else:
            binary_secret_data = get_secret_value_response['SecretBinary']

        # Your code goes here.

    return get_secret_value_response['SecretString']


def connect_to_la_city_api(app_val_token, lacity_password):
    # LADOT Parking Meter Occupancy
    client = Socrata(
            "data.lacity.org",
            app_val_token,
            username="jacobangelo_torres@yahoo.com",
            password=lacity_password,
            timeout=10
    )
    return client

def connect_to_psql_db(psql_password):
    client = boto3.client('rds')
    response = client.describe_db_instances()
    db_endpoint = ""
    for db_instance in response['DBInstances']:
        db_endpoint = db_instance['Endpoint']['Address']
        if "terraform" in db_endpoint:
            break 

    try:
        conn = psycopg2.connect(
                host=db_endpoint,
                database="tutorial", 
                user="da_admin",
                password=psql_password)
        print("was able to connect")
    except Exception as e:
        print("error when connecting")
        print(e)
        exit(1)

    return conn

def get_data_from_la_city(client, url_suffix, limit, offset, orderby):
    return client.get(url_suffix, limit = limit, offset = offset, order = orderby)

def delete_parking_data(*args, **kwargs):
    app_val_token = get_secret("app_token_value", "us-east-1")
    lacity_password = get_secret("data_lacity_password_value", "us-east-1")
    client = connect_to_la_city_api(app_val_token, lacity_password)

    psql_password = get_secret("psql_password_value", "us-east-1")
    conn = connect_to_psql_db(psql_password)

    time_3hrs_ago = datetime.now() - timedelta(hours = 3)
    time_3hrs_ago_str = time_3hrs_ago.strftime("%Y-%m-%d %H:%M:%S -0700")

    delete_sql = """
    DELETE FROM public.parking_real_time
    where event_time  < '{}'
    ;
    """.format(time_3hrs_ago_str)

    print(delete_sql)
    run_sql(conn, delete_sql)


# At minute 5 past every 3rd hour.
with DAG('delete_parking_data_dag_conn1', start_date=datetime(2024, 4, 19), schedule_interval='5 */3 * * *') as dag:
    python_task = PythonOperator(
        task_id='python_task_delete_new_parking_data',
        python_callable=delete_parking_data
    )



