# ---------- Build stage ----------
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy toàn b? mã ngu?n
COPY . .

# Cho phép ch?y mvnw n?u có (không l?i n?u thi?u quy?n)
RUN chmod +x mvnw || true

# Build b? test -> t?o JAR trong target/
RUN ./mvnw -q -DskipTests package || mvn -q -DskipTests package

# ---------- Run stage ----------
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copy JAR dã build sang image ch?y
COPY --from=build /app/target/*.jar app.jar

# Render c?p PORT qua bi?n PORT
ENV JAVA_OPTS="-Dserver.port=${PORT}"

# (tu? ch?n) múi gi? VN
# ENV TZ=Asia/Ho_Chi_Minh

EXPOSE 8080
CMD ["sh","-c","java $JAVA_OPTS -jar app.jar"]