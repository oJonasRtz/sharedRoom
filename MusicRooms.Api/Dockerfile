FROM mcr.microsoft.com/dotnet/sdk:8.0

WORKDIR /app

COPY . .

RUN dotnet restore
RUN dotnet build

EXPOSE 5032

CMD ["dotnet", "run", "--urls=http://*:5032"]