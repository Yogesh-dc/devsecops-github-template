# Use official Maven image
FROM maven:3.9.3-eclipse-temurin-17 as builder

WORKDIR /app
COPY . .

# Build the project
RUN mvn clean package -DskipTests

# Use JDK image to run the app
FROM eclipse-temurin:17-jdk
COPY --from=builder /app/target/*.jar /app/app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
