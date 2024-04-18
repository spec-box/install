# BUILD FRONTEND
FROM node:latest as frontend

RUN npm install -g npm@10.5.2

WORKDIR /web

COPY /web/. /web/

RUN sed -i 's/localhost\:5059/localhost/g' vite.config.ts
RUN npm ci


# BUILD .NET CORE APP
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY ./api/. .
RUN dotnet restore

# publish
WORKDIR /app/SpecBox.WebApi
RUN dotnet publish -c Release -o out
RUN dotnet tool install -v d --tool-path ./out thinkinghome.migrator.cli
RUN find / -type f -name 'migrate-database' -print

# PREPARE RUNTIME
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime

# install utils
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales tzdata wget iputils-ping

# lang
ENV LANG=en_US.UTF-8
RUN locale-gen "en_US.UTF-8" && dpkg-reconfigure --frontend noninteractive locales

# timezone
RUN ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

# prepare application
WORKDIR /app
COPY --from=build /app/SpecBox.WebApi/out ./
COPY --from=frontend /web ./wwwroot/
RUN rm -f appsettings.*.json

EXPOSE 80
ENV ASPNETCORE_ENVIRONMENT=Production
ENTRYPOINT ["dotnet", "SpecBox.WebApi.dll", "--urls=http://+:80"]



