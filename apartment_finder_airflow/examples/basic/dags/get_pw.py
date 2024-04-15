import boto3

from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime

def my_callable(*args, **kwargs):
    print("Hello from PythonOperator")

with DAG('my_dag', start_date=datetime(2021, 1, 1)) as dag:
    python_task = PythonOperator(
        task_id='my_python_task',
        python_callable=my_callable
    )



# def get_secret(secret_name, region):
# 	print("Getting secret {} from {}".format(secret_name, region))

# 	session = boto3.session.Session()
# 	client = session.client(
# 		service_name='secretsmanager',
# 		region_name=region,
# 	)


# 	try:
# 		get_secret_value_response = client.get_secret_value(
# 			SecretId=secret_name
# 		)
# 	except ClientError as e:
# 		if e.response['Error']['Code'] == 'ResourceNotFoundException':
# 			print("The requested secret " + secret_name + " was not found")
# 		elif e.response['Error']['Code'] == 'InvalidRequestException':
# 			print("The request was invalid due to:", e)
# 		elif e.response['Error']['Code'] == 'InvalidParameterException':
# 			print("The request had invalid params:", e)
# 		elif e.response['Error']['Code'] == 'DecryptionFailure':
# 			print("The requested secret can't be decrypted using the provided KMS key:", e)
# 		elif e.response['Error']['Code'] == 'InternalServiceError':
# 			print("An error occurred on service side:", e)
# 	else:
# 		# Secrets Manager decrypts the secret value using the associated KMS CMK
# 		# Depending on whether the secret was a string or binary, only one of these fields will be populated
# 		if 'SecretString' in get_secret_value_response:
# 			text_secret_data = get_secret_value_response['SecretString']
# 		else:
# 			binary_secret_data = get_secret_value_response['SecretBinary']

# 		# Your code goes here.

# 	return get_secret_value_response['SecretString']


# default_args = {
#     'owner': 'airflow',
#     'depends_on_past': False,
#     'email': ['test@yourdomain.com'],
#     'email_on_failure': False,
#     'email_on_retry': False
# }

# DAG_ID = "getpw"

# dag = DAG(
#     dag_id=DAG_ID,
#     default_args=default_args,
#     description='get pw test DAG',
#     schedule_interval='@once',
#     start_date=days_ago(1),
#     tags=['aws','demo'],
# )


# psql_password = get_secret("psql_password_value", "us-east-1")


# print("got it!!")
# print(psql_password)
