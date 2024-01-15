#sysbench /usr/share/sysbench/oltp_read_only.lua --db-driver=mysql --table_size=100000 --mysql-host=tmp-mysql  --mysql-db=test --mysql-user=root --mysql-password=Qampa4jLoxCSoXsG  prepare

#sysbench /usr/share/sysbench/oltp_read_only.lua --db-driver=mysql --table_size=100000 --mysql-host=tmp-mysql  --mysql-db=test --mysql-user=root --mysql-password=Qampa4jLoxCSoXsG  run


sysbench --db-driver=mysql --time=120 --threads=4 --report-interval=10 --mysql-host=st-mysql --mysql-port=3306 --mysql-user=root --mysql-password=Qampa4jLoxCSoXsG --mysql-db=test --tables=4 --table-size=100000 oltp_read_write prepare

sysbench --db-driver=mysql --time=120 --threads=4 --report-interval=10 --mysql-host=st-mysql --mysql-port=3306 --mysql-user=root --mysql-password=Qampa4jLoxCSoXsG --mysql-db=test --tables=4 --table-size=100000 oltp_read_write run


###

sysbench --db-driver=mysql --time=120 --threads=4 --report-interval=10 --mysql-host=127.0.0.1 --mysql-port=9006 --mysql-user=root --mysql-password=Qampa4jLoxCSoXsG --mysql-db=test --tables=4 --table-size=100000 oltp_read_write prepare

sysbench --db-driver=mysql --time=120 --threads=4 --report-interval=10 --mysql-host=127.0.0.1 --mysql-port=9006 --mysql-user=root --mysql-password=Qampa4jLoxCSoXsG --mysql-db=test --tables=4 --table-size=100000 oltp_read_write run

###

sysbench --db-driver=mysql --time=120 --threads=4 --report-interval=10 --mysql-host=127.0.0.1 --mysql-port=9007 --mysql-user=root --mysql-password=Qampa4jLoxCSoXsG --mysql-db=test --tables=4 --table-size=100000 oltp_read_write prepare

sysbench --db-driver=mysql --time=120 --threads=4 --report-interval=10 --mysql-host=127.0.0.1 --mysql-port=9007 --mysql-user=root --mysql-password=Qampa4jLoxCSoXsG --mysql-db=test --tables=4 --table-size=100000 oltp_read_write run
