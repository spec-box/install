# Spec Box Docker Image

## Как запустить

1. Загрузите docker образ `specbox/web` на свой компьютер

   ```sh
   docker pull docker.io/specbox/web:1.0.0
   ```

2. Запустите БД Postgres

   ```sh
   docker run --name postgres -e POSTGRES_PASSWORD=123 -e POSTGRES_DB=tms -p 5432:5432 -d postgres
   ```

3. Запустите контейнер SpecBox

   ```sh
   docker run -p 8080:80 -ti \
     --name specbox \
     --link postgres:postgres \
     -e ConnectionStrings__default='host=postgres;port=5432;database=tms;user name=postgres;password=123' \
     specbox/web:1.0.0
   ```

4. В отдельной вкладке тенминала запустите инициализацию БД (инициализировать БД необходимо только при первом запуске и при обновлении SpecBox)

   ```sh
   docker exec -ti specbox ./SpecBox.CLI migrate
   ```

5. Если необходимо, запустите команду создания нового проекта (в отдельной вкладке тенминала)

   ```sh
   docker exec -ti specbox ./SpecBox.CLI project create <project-id> "<Название проекта>"
   ```

6. Вы можете выгрузить в SpecBox [наш демонстрационный проект](https://github.com/spec-box/example). Перед выгрузкой укажите ID проекта и хост Spec Box в конфигурационном файле `.tms.json`.

### ДЛЯ РАЗРАБОТЧИКОВ!

1. Установите:

- git
- docker

2. Загрузите проект на свой компьютер

   ```sh
   git clone https://github.com/spec-box/install.git spec-box-install
   cd spec-box-install
   ```

3. Залогиньтесь в docker

   ```sh
   docker login
   ```

4. Обновите версию в файле `./setup.sh`, соберите образ и загрузите в registry

   ```sh
   ./setup.sh
   ```
