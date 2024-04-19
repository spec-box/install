# install

## Pre-requisites

- git
- docker


## Pull the spec-box image
```shell
docker pull docker.io/pk72/spec-box
```

## Initialize database (ONCE!)

Startup database if you don't have database already.
```shell
docker run --name postgres -e POSTGRES_PASSWORD=123 -e POSTGRES_DB=tms -p 5432:5432 -d postgres
```

Apply the migrations (adjust the connection string if you're using your own database.
```shell
docker run -it --link postgres:postgres --entrypoint ./migrate-database docker.io/pk72/spec-box:latest postgres "host=postgres;port=5432;database=tms;user name=postgres;password=123" ./migrations/SpecBox.Migrations.dll
```

## Ready to run
```shell
docker run -p 80:80 -ti \
 --link postgres:postgres \
 -e ConnectionStrings__default='host=postgres;port=5432;database=tms;user name=postgres;password=123' \
 docker.io/pk72/spec-box:latest
```


## Clone the example data
```shell
git clone https://github.com/spec-box/example.git
cd example
```

## Validate the example data
```shell
docker run -it --entrypoint npx --mount type=bind,source=./,target=/app/specs docker.io/pk72/spec-box-sync:latest spec-box validate
```

## Sync the example data (i.e. upload to the project database).
```shell
docker run --network="host" -it --entrypoint npx --mount type=bind,source=./,target=/app/specs docker.io/pk72/spec-box-sync:latest spec-box sync
```

## Ok, you're ready to view the results. open the browser and see the results.
```url
http://localhost/
```



### FOR DEVELOPERS ONLY!
## Pushing an IMAGE
Clone the project, and run setup.sh
```shell
git clone https://github.com/spec-box/install.git
cd install
sh ./setup.sh
```

Before pushing you've to login to docker hub with account which has the rights to push.

```shell
docker login
```

Then perform a build and push the image to latest.


```shell
docker-compose build
docker push docker.io/pk72/spec-box
```

And with the version tag as the following:
```shell
VERSION=0.1.1 docker push docker.io/pk72/spec-box
```

