# Stage 1: Build the application
FROM maven:3.9.4-eclipse-temurin-17 AS build

# Create a non-root user
RUN useradd -ms /bin/bash builder

# Create a directory for Maven's local repository and set ownership
RUN mkdir -p /app /home/builder/.m2 && chown -R builder:builder /app /home/builder/.m2

# Set environment variables to point Maven to the custom repository
ENV MAVEN_CONFIG=/home/builder/.m2

# Switch to the non-root user
USER builder

# Set the working directory
WORKDIR /app

# Copy only the necessary files to build the project
COPY --chown=builder:builder pom.xml .
COPY --chown=builder:builder src ./src

# Build the application
RUN mvn clean package -DskipTests




# Stage 2: Create a lightweight runtime image
FROM openjdk:17-jdk-slim

# Set environment variables to prevent runtime risks
ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom"

# Create a non-root user for running the application
RUN useradd -ms /bin/bash appuser
USER appuser

# Set the working directory
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/*-SNAPSHOT.jar app.jar

# Expose the application port
EXPOSE 8080

# Add a health check for the application
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s CMD curl -f http://localhost:8080/ || exit 1

# Run the application as a non-root user
CMD ["java", "-jar", "app.jar"]