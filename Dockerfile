FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 53457
EXPOSE 44335

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["MyFinAPP/MyFinAPP.csproj", "MyFinAPP/"]
RUN dotnet restore "MyFinAPP/MyFinAPP.csproj"
COPY . .
WORKDIR "/src/MyFinAPP"
RUN dotnet build "MyFinAPP.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "MyFinAPP.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "MyFinAPP.dll"]