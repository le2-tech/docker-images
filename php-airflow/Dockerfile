ARG BASE_IMAGE
ARG BASE_IMAGE_TAG
FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG}

SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "nounset", "-o", "nolog", "-c"]

USER root

RUN set -eux ;\
    apt update ;\
    apt install -y --no-install-recommends \
        dumb-init \
        python3-venv \
        gcc \
        python3-dev \
        netcat-openbsd \
    ;\
    rm -rf /var/lib/apt/lists/* ;

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

ARG AIRFLOW_HOME=/opt/airflow
ARG AIRFLOW_UID="50000"
ARG AIRFLOW_USER_HOME_DIR=/home/airflow
ARG AIRFLOW_VERSION=2.9.0

WORKDIR ${AIRFLOW_HOME}

RUN set -eux ; \
    PYTHON_VERSION="$(python -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')" ;\
    CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt" ;\
    pip install "apache-airflow[celery]==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}" ;\
    pip install psycopg2 'redis' 'SQLAlchemy' ;

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
    # && airflow config list --defaults > "${AIRFLOW_HOME}/airflow.cfg"

COPY --from=apache/airflow:2.9.0 --chown=airflow:0 /entrypoint /entrypoint
# COPY --chown=airflow:0 entrypoint_prod.sh /entrypoint

RUN chmod a+x /entrypoint \
    && chmod g=u /etc/passwd \
    && usermod -g 0 airflow -G 0

# RUN sed --in-place=.bak "s/secure_path=\"/secure_path=\"$(echo -n ${AIRFLOW_USER_HOME_DIR} | \
#         sed 's/\//\\\//g')\/.local\/bin:/" /etc/sudoers

ENV AIRFLOW_UID=${AIRFLOW_UID} \
    AIRFLOW_USER_HOME_DIR=${AIRFLOW_USER_HOME_DIR} \
    AIRFLOW_HOME=${AIRFLOW_HOME} \
    PIP_USER="true"

ENV DUMB_INIT_SETSID="1" \
    PS1="(airflow)"


USER ${AIRFLOW_UID}
# USER root


# ENTRYPOINT [""]
# ENTRYPOINT ["/entrypoint"]
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/entrypoint"]
CMD []
