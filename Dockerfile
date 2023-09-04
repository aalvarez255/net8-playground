FROM mcr.microsoft.com/dotnet/sdk:8.0-preview AS build

WORKDIR /app

COPY . ./

RUN dotnet restore
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:8.0-preview
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "net8-playground.dll"]