FROM openjdk:17
EXPOSE 8082
COPY src/main/resources src/main/resources
ARG JAR_FILE=target/fhir-server-services-0.0.1.jar
COPY ${JAR_FILE} fhirserver.jar
ENTRYPOINT ["java","-jar","/fhirserver.jar"]