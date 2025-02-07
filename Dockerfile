FROM openjdk:17-alpine
COPY my-app-1.0-SNAPSHOT.jar /app.jar
CMD ["java", "-jar", "/app.jar"]
