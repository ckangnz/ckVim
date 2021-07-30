# DOTNET

## Commands

```sh
  dotnet new webapi -n {NAME-OF-PROJECT}
  dotnet build
  dotnet run //check launchSettings.json for port configuration
```

## Adding healthcheck middleware

```cs
public void ConfigureServices(IServiceCollection services)
{
    services.AddControllers();
    services.AddHealthChecks();
    services.AddSwaggerGen(c =>
    {
        c.SwaggerDoc("v1", new OpenApiInfo { Title = "NAME-OF-PROJECT", Version = "v1" });
    });
}

public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
{
    app.UseHealthChecks("/ping");
}
```

## Dockerize dotnet project

```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /app
COPY . ./NAME-OF-PROJECT
WORKDIR /app/NAME-OF-PROJECT
RUN dotnet restore
RUN dotnet build

FROM build AS publish
WORKDIR /app/NAME-OF-PROJECT
RUN dotnet publish NAME-OF-PROJECT.csproj --configuration Release --no-restore --output /release

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS final
EXPOSE 80
EXPOSE 443
WORKDIR /app/NAME-OF-PROJECT
COPY --from=publish /release .

ENTRYPOINT [ "dotnet", "NAME-OF-PROJECT.dll" ]
```

## Run docker run project

```
// to build docker image
docker build -t IMAGE-NAME-TAG .

// to run a container with the image
// Run -Detached -Port 1111:80
docker run -rm -d -p 1111:80 IMAGE-NAME-TAG
```
