#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["testApp/testApp.csproj", "testApp/"]
RUN dotnet restore "testApp/testApp.csproj"
COPY . .
WORKDIR "/src/testApp"
RUN dotnet build "testApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "testApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "testApp.dll"]
