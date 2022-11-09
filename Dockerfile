# 이미지 생성시 사용할 이미지
FROM apache/airflow:2.4.2-python3.7

# 이미지 빌드, 컨테이너 실행 모두 사용가능한 환경변수
ENV AIRFLOW__KUBERNETES__FS_GROUP=50000
ENV AIRFLOW__KUBERNETES__RUN_AS_USER=50000

# 이미지 빌드(RUN)까지 사용가능한 변수
ARG DEST_INSTALL=/home/airflow

# (root) apt 패키지 추가
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    && apt-get autoremove -yqq --purge \
    && apt-get clean  \
    && rm -rf /var/lib/apt/lists/*

# (airflow) 새로운 PyPI 패키지 추가
USER airflow
WORKDIR ${DEST_INSTALL}

ENV PATH=${PATH}:/home/airflow/.local/bin

ARG UPDATE_PIP_VERSION_TO="22.3.1"
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py --user pip==${UPDATE_PIP_VERSION_TO} && \
    pip install pipenv

ENV PYTHONPATH="${AIRFLOW_HOME}:${PYTHONPATH}"

COPY Pipfile* ${DEST_INSTALL}/
RUN pipenv install --system --ignore-pipfile --deploy

# (root) airflow db 초기화 및 webserver 실행
USER root

### update entrypoint: add "airflow initdb" command
### before running the webserver
COPY ./entrypoint_* /
RUN sed -i "s/exec airflow.*/###/g" /entrypoint && \
    cat /entrypoint_update_exec >> /entrypoint

ENV AIRFLOW__KUBERNETES__KUBE_CLIENT_REQUEST_ARGS=""

COPY ./dags/ ${AIRFLOW_HOME}/dags/

# Make sure Airflow is owned by airflow user
RUN chown -R "airflow" "${AIRFLOW_HOME}"

USER airflow
WORKDIR ${AIRFLOW_HOME}