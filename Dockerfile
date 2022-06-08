FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build-env
WORKDIR /app

COPY src/dbup-cli ./
RUN dotnet publish --restore -c Release -o out -f net6.0 -r linux-musl-x64 --self-contained  /p:PublishSingleFile=true /p:IncludeAllContentForSelfExtract=true



FROM alpine

LABEL org.opencontainers.image.title="dbup-cli"
LABEL org.opencontainers.image.source="https://github.com/lbguilherme/dbup-cli"

RUN apk add --no-cache libgcc libstdc++ icu
COPY --from=build-env /app/out/dbup-cli /usr/bin/
CMD ["/usr/bin/dbup-cli"]
