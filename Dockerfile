
FROM maven:3.9.11-eclipse-temurin-17 AS builder

WORKDIR /workspace

# Install the shared Maven parent inside the Docker build
COPY gwatcho-maven-parent/pom.xml /tmp/gwatcho-maven-parent/pom.xml

RUN mvn -B -f /tmp/gwatcho-maven-parent/pom.xml install -N

# Copy and build only the product service
COPY gwatcho-product-service/pom.xml /workspace/gwatcho-product-service/pom.xml
COPY gwatcho-product-service/src /workspace/gwatcho-product-service/src

RUN mvn -B -f /workspace/gwatcho-product-service/pom.xml clean package -DskipTests

FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=builder /workspace/gwatcho-product-service/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
