# Image de base OpenJDK 11
FROM eclipse-temurin:17-jdk

# Copier le jar de l'application dans l'image
COPY target/student-management-0.0.1-SNAPSHOT.jar app.jar

# Exposer le port de l'application
EXPOSE 8080

# Commande pour lancer l'application
ENTRYPOINT ["java", "-jar", "app.jar"]
