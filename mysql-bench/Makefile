include ./.env

run:
	docker run --name my-mysql \
		--env-file .env \
		-p ${MYSQL_PORT}:3306 \
		-d mysql:9.1

benchmark:
	sysbench --db-driver=mysql --time=120 --threads=4 --report-interval=10 --mysql-host=127.0.0.1 --mysql-port=${MYSQL_PORT} --mysql-user=root --mysql-password=${MYSQL_ROOT_PASSWORD} --mysql-db=${MYSQL_DATABASE} --tables=4 --table-size=100000 oltp_read_write prepare
	sysbench --db-driver=mysql --time=120 --threads=4 --report-interval=10 --mysql-host=127.0.0.1 --mysql-port=${MYSQL_PORT} --mysql-user=root --mysql-password=${MYSQL_ROOT_PASSWORD} --mysql-db=${MYSQL_DATABASE} --tables=4 --table-size=100000 oltp_read_write run
