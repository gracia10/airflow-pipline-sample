from datetime import datetime

from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import PythonOperator

dag = DAG(
    dag_id="hello_goodbye_DAG",
    start_date=datetime(2022, 11, 11),
    schedule="0 5 * * *",
    catchup=False,
    tags=['example'])


def print_hello():
    print("hello!")
    return "hello"


def print_goodbye():
    print("goodbye!")
    return "goodbye"


# DummyOperator < 2.3.1
start = EmptyOperator(dag=dag, task_id="start")

print_hello = PythonOperator(
    task_id='print_hello',
    python_callable=print_hello,
    dag=dag
)

print_goodbye = PythonOperator(
    task_id='print_goodbye',
    python_callable=print_goodbye,
    dag=dag
)

end = EmptyOperator(dag=dag, task_id="end")

start >> [print_hello, print_goodbye] >> end
