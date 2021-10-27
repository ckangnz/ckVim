# MSSQL commands

> How to connect to dockerised mssql-linux ([Docker Hub - Microsoft-sql-server](https://hub.docker.com/_/microsoft-mssql-server))

```bash
docker pull mcr.microsoft.com/mssql/server
docker run <mssql-image>
docker exec -it <containerName> /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P <userpassword>
```

### Databases

```bash
   //Show all databases
   select name from sys.databases;
   go

   //Use databases
   use <db_name>
   go
```

### Listing tables

```bash
   select * from INFORMATION_SCHEMA.TABLES;
   go
```
