FROM phpcli:local

# change user
USER root

RUN apt update -y \
    && apt-get upgrade -y \
    && apt-get install -y build-essential python3-dev sqlite3 libsqlite3-dev openssl default-libmysqlclient-dev postgresql netcat \
    && apt-get install -y --no-install-recommends freetds-dev libkrb5-dev libsasl2-dev libssl-dev libffi-dev libpq-dev  \
    && apt-get install -y dumb-init sudo yarn lsb-release python3 python-is-python3 python3-pip gosu \
    && apt-get clean

ARG AIRFLOW_HOME=/opt/airflow
ARG AIRFLOW_UID="50000"
ARG AIRFLOW_USER_HOME_DIR=/home/airflow
ARG AIRFLOW_VERSION=2.4.1

RUN PYTHON_VERSION="$(python --version | cut -d " " -f 2 | cut -d "." -f 1-2)" \
    && echo ${PYTHON_VERSION} \
    && CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt" \
    && echo ${CONSTRAINT_URL} \
    && pip install "apache-airflow[celery, redis, postgres, ssh, s3, mysql]==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}" \
    && pip install psycopg2 \
    && pip install 'redis' \
    && pip install 'SQLAlchemy'

RUN adduser --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password \
           --quiet "airflow" --uid "${AIRFLOW_UID}" --gid "0" --home "${AIRFLOW_USER_HOME_DIR}" \
# Make Airflow files belong to the root group and are accessible. This is to accommodate the guidelines from
# OpenShift https://docs.openshift.com/enterprise/3.0/creating_images/guidelines.html
    && mkdir -pv "${AIRFLOW_HOME}" \
    && mkdir -pv "${AIRFLOW_HOME}/dags" \
    && mkdir -pv "${AIRFLOW_HOME}/logs" \
    && chown -R airflow:0 "${AIRFLOW_USER_HOME_DIR}" "${AIRFLOW_HOME}" \
    && chmod -R g+rw "${AIRFLOW_USER_HOME_DIR}" "${AIRFLOW_HOME}" \
    && find "${AIRFLOW_HOME}" -executable -print0 | xargs --null chmod g+x \
    && find "${AIRFLOW_USER_HOME_DIR}" -executable -print0 | xargs --null chmod g+x

COPY --chown=airflow:0 entrypoint_prod.sh /entrypoint
RUN chmod a+x /entrypoint \
    && chmod g=u /etc/passwd \
    && usermod -g 0 airflow -G 0

RUN sed --in-place=.bak "s/secure_path=\"/secure_path=\"\/.venv\/bin:/" /etc/sudoers

ENV AIRFLOW_UID=${AIRFLOW_UID} \
    AIRFLOW_USER_HOME_DIR=${AIRFLOW_USER_HOME_DIR} \
    AIRFLOW_HOME=${AIRFLOW_HOME} \
    PIP_USER="true"

ENV DUMB_INIT_SETSID="1" \
    PS1="(airflow)" \
    LD_PRELOAD="/usr/lib/aarch64-linux-gnu/libstdc++.so.6"

USER ${AIRFLOW_UID}

WORKDIR ${AIRFLOW_HOME}


ENTRYPOINT ["/usr/bin/dumb-init", "--", "/entrypoint"]
CMD []
