# DOTNET

## Installing Dotnet with multiple SDK versions

Visit [here](https://github.com/isen-ng/homebrew-dotnet-sdk-versions) for more versions

```sh
# Install dotnet with sdk handler (this will get the latest version as well)
brew install dotnet-sdk

# Install dotnet versions
brew tap isen-ng/dotnet-sdk-versions
brew install --cask <VERSION> # e.g. dotnet-sdk6-0-200

# Check default version
dotnet --version

# List versions
dotnet --list-sdks

# List available templates with dotnet new
dotnet new list

# E.g. Create webapi
dotnet new webapi
  -n {NAME-OF-PROJECT}        #name
  -o                          #output directory
  -f {net7.0|net8.0}          #framework
  -controllers                #use controllers
```

## Commands

- The port is set in `launchSettings.json`

```sh
dotnet build
dotnet run
dotnet watch run #Opens browser
dotnet clean #run this to clean up the .dll

# To run dotnet project using specific Nuget.Config
dotnet run --project .csproj_PATH --configFile Nuget.Config_PATH
```

> If your `dotnet run` fails to find the SDK, make sure to have the `global.json` to specify the correct version. [Refer to this documentation](https://learn.microsoft.com/en-us/dotnet/core/versions/selection#the-sdk-uses-the-latest-installed-version)

> If you run in to SSL issue run this command

```sh
dotnet dev-certs https --trust
```

### Adding healthcheck middleware

##### For Dotnet 3 & 5

```cs
# Startup.cs

public void ConfigureServices(IServiceCollection services)
{
    services.AddControllers();
    services.AddHealthChecks(); #<-- Add This
    services.AddSwaggerGen(c =>
    {
        c.SwaggerDoc("v1", new OpenApiInfo { Title = "NAME-OF-PROJECT", Version = "v1" });
    });
}

public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
{
    app.UseHealthChecks("/healthz"); #<-- Add This
}
```

##### For Dotnet 6

> [For more information](https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/health-checks?view=aspnetcore-6.0)

```cs
# Program.cs

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddControllers();
builder.Services.AddHealthChecks(); #<-- Add this
builder.Services.AddSwaggerGen();

var app = builder.Build();
app.MapHealthChecks("/healthz"); #<-- Add this

app.Run();
```

### Updating the launch URL

To change the initial launch url, update it in the `launchSettings.json`

```json
{
  "launchUrl": "api/todoitems"
}
```

## Adding a Model class & DB Context

- Model classes can go anywhere in the project, but the `Models` folder is used by convention.
- The _database context_ is the main class that coordinates Entity Framework functionality for a data model.
- This class is created by deriving from the `Microsoft.EntityFrameworkCore.DbContext` class.

> Run `dotnet add package Microsoft.EntityFrameworkCore.InMemory` to use Entity Framework in the project.

```cs
using Microsoft.EntityFrameworkCore;
using System.Diagnostics.CodeAnalysis;

namespace <PROJECT>.Model
{
  public class <MODEL>
  {
    public long Id { get; set; }
    public string? Name { get; set; }
    public bool IsSomething { get; set; }
  }

  public class <MODELCONTEXT> : DbContext
  {
    public <MODELCONTEXT>(DbContextOptions<<MODELCONTEXT>> options)
      :base(options)
    {}

    public DbSet<MODEL> <MODEL>s { get; set; } = null!;
  }
}
```

Now register the database context to `Program.cs`

```cs
using Microsoft.EntityFrameworkCore;
using TodoApi.Models;

builder.Services.AddDbContext<DC_NAME>(opt => opt.UseInMemoryDatabase("InMemoryDbName"));
# builder.Services.AddDbContext<DC_NAME>(opt => opt.UseInMemoryDatabase("TodoList"));
```

## Adding a controller

### Pre-requisites

> You MUST create controller/db context and register the db context to the service before scaffolding the controller

```sh
dotnet add package Microsoft.VisualStudio.Web.CodeGeneration.Design
dotnet add package Microsoft.EntityFrameworkCore.Design
dotnet add package Microsoft.EntityFrameworkCore.SqlServer

dotnet tool install -g dotnet-aspnet-codegenerator
# This will require your .zshrc to be updated
```

### Generate Controller with CLI

Let's use the `dotnet-aspnet-codegenerator` to automatically scaffold the controller!

```sh
dotnet aspnet-codegenerator controller
  -name <CONTROLLER_NAME>
  -async
  -api
  -m <MODELNAME>
  -dc <DC_NAME>
  -outDir Controllers
```

#### Update [POST] method

> Everything should be created automatically. Simply update response for POST to use `nameof`

```cs
//return CreatedAtAction("GetTodoItem", new { id = todoItem.Id }, todoItem);
return CreatedAtAction(nameof(GetTodoItem), new { id = todoItem.Id }, todoItem);
```

## Test with the REST call (use your tool!)

```http
GET https://localhost:7146/api/todoitems HTTP/1.1
Content-Type: application/json

-----------

GET https://localhost:7146/api/todoitems/{3} HTTP/1.1
Content-Type: application/json

-----------

POST https://localhost:7146/api/todoitems HTTP/1.1
Content-Type: application/json

{
  "name":"hello",
  "isCompleted":false
}

-----------

PUT https://localhost:7146/api/todoitems/1 HTTP/1.1
Content-Type: application/json

{
  "id": 1,
  "name":"Updated",
  "isCompleted":true
}

-----------

DELETE https://localhost:7146/api/todoitems/1 HTTP/1.1
```
