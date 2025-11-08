# Use OpenJDK 17 for build (Java 8 is outdated)
FROM eclipse-temurin:17-jdk-alpine AS builder

# Create build directory
WORKDIR /app/source


#Copy Maven wrapper and project files 

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src ./src

#give mvnw execute permission and build 
RUN chmod +x mvnw && ./mvnw clean package -DskipTests


#runtime stage

FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app
COPY --from=builder  /app/source/target/*.jar app.jar 
EXPOSE 8080
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/urandom", "-jar", "/app/app.jar"]
