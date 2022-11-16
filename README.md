# airflow-pipline-sample

__환경__
- docker-compose v2.12.1
- docker v20.10.20
- python v3.7
- pip v22.0.4
- airflow v2.4.2


__환경 셋팅 과정__
- docker 엔진 설치
  - 도커 데스트탑 설정, 메모리 8G 로 변경
- 마운트될 폴더 준비 
  - `mkdir data logs dags plugins`
- 커스텀 Pipy 패키지 준비
  - `pip install pipenv`
  - requirements.txt 생성 [참고 - dependencies of airflow](https://airflow.apache.org/docs/apache-airflow/stable/extra-packages-ref.html)
  - Pipfile 생성 `pipenv --python 3.7 install -r requirements.txt `
- `docker-compose.yaml` 작성
  - entrypoint 스크립트 작성 (airflow db 초기화)
  - Dokerfile 작성 (Pipy 패키지, entrypoint 실행)
- 실행
  - `docker-compose up`

---
