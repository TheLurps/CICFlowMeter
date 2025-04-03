ARG MAVEN_TAG=3.8.7-openjdk-18-slim
FROM docker.io/library/maven:${MAVEN_TAG}

# Install libpcap headers
ARG DEBIAN_FRONTEND=noninteractive
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpcap-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files
COPY pom.xml .
COPY src ./src

# Install jnetpcap manually into local Maven repo
COPY jnetpcap/linux/jnetpcap-1.4.r1425 ./jnetpcap
RUN mvn install:install-file \
    -Dfile=jnetpcap/jnetpcap.jar \
    -DgroupId=org.jnetpcap \
    -DartifactId=jnetpcap \
    -Dversion=1.4.1 \
    -Dpackaging=jar

# Build the application
RUN mvn package -DskipTests

# Run the app
ENV LD_LIBRARY_PATH /app/jnetpcap/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
