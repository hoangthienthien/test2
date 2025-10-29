# ---------- Build stage ----------
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy to�n b? m� ngu?n
COPY . .

# Cho ph�p ch?y mvnw n?u c� (kh�ng l?i n?u thi?u quy?n)
RUN chmod +x mvnw || true

# Build b? test -> t?o JAR trong target/
RUN ./mvnw -q -DskipTests package || mvn -q -DskipTests package

# ---------- Run stage ----------
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copy JAR d� build sang image ch?y
COPY --from=build /app/target/*.jar app.jar

# Render c?p PORT qua bi?n PORT
ENV JAVA_OPTS="-Dserver.port=${PORT}"

# (tu? ch?n) m�i gi? VN
# ENV TZ=Asia/Ho_Chi_Minh

EXPOSE 8080
CMD ["sh","-c","java $JAVA_OPTS -jar app.jar"]