FROM mcr.microsoft.com/dotnet/sdk:7.0.402-bullseye-slim-arm64v8 AS base
#VOLUME /home/pi/Arm64
#VOLUME /opt/vc
# ENV LD_LIBRARY_PATH="/opt/vc/lib:${LD_LIBRARY_PATH}"

WORKDIR /source

COPY ASP-Portfolio/*.csproj .
RUN dotnet restore -r linux-arm64

COPY ASP-Portfolio/ .
RUN dotnet publish --self-contained false -c Release -r linux-arm64 -o /app

# # Generate runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0-bullseye-slim-arm64v8
WORKDIR /app
EXPOSE 5000
# Set the ASPNETCORE_URLS environment variable
ENV ASPNETCORE_URLS=http://+:5000
COPY --from=base /app .
ENTRYPOINT [ "./ASPPortfolio" ]
