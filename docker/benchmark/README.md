# Description

Docker images containing benchmark tools and Yugabyte client

## Benchmark tools

### Sysbench
Yugabyte sysbench is complied from source and install

To run sysbench you can use the included run_sysbench.sh file.

1. Build the image if not done yet
2. Customize the files for you need (username, password, ip)
3. Run the following command

```shell
# From this directory
# resultat will be written in the current directory as well
# You can change the mounting path if needed
docker run -it -v $(pwd)/sysbench:/conf/ -v $(pwd):/res/ yb-benchmark /conf/run_sysbench.sh
```
4. Alternatively you can just create a shell and run everything from there

```shell
docer run -it -v $(pwd)/sysbench:/conf/ -v $(pwd):/res/  yb-benchmark /bin/bash
```


## Build Docker images

From the current directory

```shell
docker build -t yb-benchmark .
```

