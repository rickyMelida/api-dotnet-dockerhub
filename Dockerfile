# Use la imagen base oficial de .NET SDK (para compilación)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copie los archivos .csproj y restaure las dependencias
COPY *.csproj ./
RUN dotnet restore

# Copie el resto de los archivos y compile la aplicación
COPY . ./
RUN dotnet publish -c Release -o out

# Use una imagen base de .NET Runtime para la ejecución
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .

# Exponer el puerto que la aplicación está escuchando
EXPOSE 80

# Defina el punto de entrada para el contenedor
ENTRYPOINT ["dotnet", "simple-api-dockerhub.dll"]
