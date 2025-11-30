# Build stage
FROM dart:stable AS build
WORKDIR /app

# Fix DNS for Docker/Alpine-like behavior when resolving pub.dev
RUN echo "hosts: files dns" > /etc/nsswitch.conf

# Force Dart/pub to only use IPv4
ENV PUB_HOSTED_URL=https://pub.dev
ENV DART_VM_OPTIONS="--ipv6=false --use_ipv4_only=true"

# Copy only pubspec files first (cache pub get)
COPY pubspec.* ./

# First pub get (online)
RUN dart pub get

# Copy rest of the source code
COPY . .

# Second pub get using the local cache (much more reliable)
RUN dart pub get --offline

# Compile the server
RUN dart compile exe bin/main.dart -o bin/server


# Final stage
FROM alpine:latest

# Required for Dart executables
RUN apk add --no-cache libstdc++

# Environment variables
ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

# Copy runtime dependencies
COPY --from=build /runtime/ /

# Copy compiled server executable
COPY --from=build /app/bin/server server

# Copy config files and resources
COPY --from=build /app/config/ config/
COPY --from=build /app/web/ web/
COPY --from=build /app/migrations/ migrations/

# Required for insights endpoint log filter
COPY --from=build /app/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

# Expose ports
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# Entrypoint
ENTRYPOINT ./server --mode=$runmode --server-id=$serverid --logging=$logging --role=$role --apply-migrations
