FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /ConsoleApp1

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /ConsoleApp1
COPY --from=build-env /ConsoleApp1/out .
ENTRYPOINT ["dotnet", "DotNet.Docker.dll"]