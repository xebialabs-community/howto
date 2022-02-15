FROM openjdk:8-jdk-alpine
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} simple-webapp.jar
ENTRYPOINT ["java","-jar","/simple-webapp.jar"]

