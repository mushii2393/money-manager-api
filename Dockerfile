# Step 1: Build stage
FROM maven:3.9.6-eclipse-temurin-21 AS build

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

WORKDIR /app

# Copy pom.xml first to leverage caching
COPY pom.xml .
RUN mvn dependency:resolve

# Copy source code
COPY src ./src

# Build the jar
RUN mvn clean package -DskipTests

# Step 2: Run stage
FROM eclipse-temurin:21-jdk-alpine

WORKDIR /app

# Copy the jar from build stage
COPY --from=build /app/target/moneymanager-0.0.1-SNAPSHOT.jar app.jar

# Expose your port (you can choose 8080 or 9090)
EXPOSE 8080

# Run the app
ENTRYPOINT ["java","-jar","app.jar"]
