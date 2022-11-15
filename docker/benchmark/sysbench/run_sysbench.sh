#!/bin/bash

# Get the IP, numtables and the tablesize from the user. 
# The default value for the numtables is 10, tablesize is 100k and for the ip is '127.0.0.1'.
# username is yugabyte, password is empty
db=yugabyte
ip="127.0.0.1"
numtables=10
# If you have a password, for sysbench add the pg-pasword command line as well
# ie. password="--pgsql-password=my_secure_password"
password=""
port=5433
run_threads=64
tablesize=100000
time=120
user=yugabyte


delete_tables() {
  # Make sure that ysqlsh is present in the 'PATH'.
  tables=$(for i in `seq $numtables` ; do printf ",sbtest%s" $i; done)
  echo "drop table ${tables:1}"
  ysqlsh -h $ip -c "drop table ${tables:1};"
}

run_workload() {
  echo "RUNNING $1"
  echo Writing output to /res/$1-load.dat and /res/$1-run.dat
  time sysbench $1 --tables=$numtables --table-size=$tablesize --range_key_partitioning=true --serial_cache_size=1000 --db-driver=pgsql --pgsql-host=$ip --pgsql-port=$port --pgsql-user=$user $password --pgsql-db=$db prepare > /res/$1-load.dat
  time sysbench $1 --tables=$numtables --table-size=$tablesize --range_key_partitioning=true --serial_cache_size=1000 --db-driver=pgsql --pgsql-host=$ip --pgsql-port=$port --pgsql-user=$user $password --pgsql-db=$db --threads=$run_threads --time=$time --warmup-time=120 run > /res/$1-run.dat
  delete_tables
  echo "DONE $1"
}

delete_tables
run_workload oltp_insert
run_workload oltp_point_select
run_workload oltp_write_only
run_workload oltp_read_only
run_workload oltp_read_write
run_workload oltp_update_index
run_workload oltp_update_non_index
run_workload oltp_delete