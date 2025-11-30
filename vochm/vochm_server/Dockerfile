# Build stage
FROM dart:3.5.0 AS build
WORKDIR /app

# Kopiera projektfiler
COPY . .

# Kopiera cache från hosten
COPY pub-cache /root/.pub-cache

# Kör pub get offline med cache
RUN dart pub get --offline

# Kompilera servern
RUN dart compile exe bin/main.dart -o bin/server

# Final stage
FROM alpine:latest

# Environment variables
ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

# Copy runtime dependencies
COPY --from=build /runtime/ /

# Copy compiled server executable
COPY --from=build /app/bin/server server

# Copy configuration files and resources
COPY --from=build /app/config/ config/
COPY --from=build /app/web/ web/
COPY --from=build /app/migrations/ migrations/

# This file is required to enable the endpoint log filter in Insights.
COPY --from=build /app/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

# Expose ports
EXPOSE 8080 8081 8082

# Define the entrypoint command
ENTRYPOINT ./server --mode=$runmode --server-id=$serverid --logging=$logging --role=$role --apply-migrations
