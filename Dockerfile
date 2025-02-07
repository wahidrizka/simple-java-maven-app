FROM openjdk:17-alpine

WORKDIR /app

COPY my-app-1.0-SNAPSHOT.jar /app.jar

CMD ["java", "-jar", "/app.jar"]
