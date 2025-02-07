FROM amazoncorretto:17

WORKDIR /home/ec2-user/app

COPY my-app-1.0-SNAPSHOT.jar app.jar

CMD ["java", "-jar", "app.jar"]
