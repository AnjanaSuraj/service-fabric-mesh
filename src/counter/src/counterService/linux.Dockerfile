FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
# Using sfvolume here does not matter as code files are in this directory.
COPY sfvolume/counterService/counterService.csproj sfvolume/counterService/
RUN dotnet restore sfvolume/counterService/counterService.csproj
COPY . .
WORKDIR /src/sfvolume/counterService
RUN dotnet build counterService.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish counterService.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "counterService.dll"]
