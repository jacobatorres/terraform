from airflow import DAG
from datetime import datetime, timedelta
from airflow.utils.dates import days_ago
from airflow.operators.bash_operator import BashOperator

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email': ['test@yourdomain.com'],
    'email_on_failure': False,
    'email_on_retry': False
}

DAG_ID = "pinoyprideff"

dag = DAG(
    dag_id=DAG_ID,
    default_args=default_args,
    description='Scheduled Apache Airflow DAG',
    schedule_interval='* 1 * * *',
    start_date=days_ago(1),
    tags=['aws','demo'],
)


say_hello = BashOperator(
        task_id='saykumusta',
        bash_command="echo kumustana" ,
        dag=dag
    )

say_goodbye = BashOperator(
        task_id='saygoodbye',
        bash_command="echo babayna",
        dag=dag
    )

say_hello >> say_goodbye
