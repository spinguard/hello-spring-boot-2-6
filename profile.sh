#!/bin/bash

source ~/.sdkman/bin/sdkman-init.sh

## baseline JDK 8
sdk use java 8.0.392-librca

./mvnw -q clean package spring-boot:start -DskipTests  2>&1 | tee 'java8with2.6.spring-boot.log' &

sleep 10

pid=$(jps | grep 'HelloSpringApplication' | cut -d ' ' -f 1)
rss=$(ps -o rss= "$pid" | tail -n1)
mem_usage=$(bc <<< "scale=1; ${rss}/1024")
echo "The process was using ${mem_usage} megabytes"
echo "${mem_usage}" >> java8with2.6.spring-boot.log2

./mvnw spring-boot:stop -Dspring-boot.stop.fork

## Upgrade

./mvnw -U org.openrewrite.maven:rewrite-maven-plugin:run -Drewrite.recipeArtifactCoordinates=org.openrewrite.recipe:rewrite-spring:LATEST -DactiveRecipes=org.openrewrite.java.spring.boot3.UpgradeSpringBoot_3_2

## Run JDK 21 with GraalVM JDK

sdk use java 23.1.2.r21-nik

./mvnw -q clean package spring-boot:start -DskipTests  2>&1 | tee 'java21with3.2.spring-boot.log' &

sleep 10

pid=$(jps | grep 'HelloSpringApplication' | cut -d ' ' -f 1)
rss=$(ps -o rss= "$pid" | tail -n1)
mem_usage=$(bc <<< "scale=1; ${rss}/1024")
echo "The process was using ${mem_usage} megabytes"
echo "${mem_usage}" >> java21with3.2.spring-boot.log2

./mvnw spring-boot:stop -Dspring-boot.stop.fork

## Build Native

./mvnw -Pnative native:compile

./target/hello-spring 2>&1 | tee nativeWith3.2.log &

sleep 10

pid=$(pgrep hello-spring)
rss=$(ps -o rss= "$pid" | tail -n1)
mem_usage=$(bc <<< "scale=1; ${rss}/1024")
echo "The process was using ${mem_usage} megabytes"
echo "${mem_usage}" >> nativeWith3.2.log2

kill -9 $pid

# Run with Liberica Java 21

sdk use java 21.0.2-librca

./mvnw -q clean package spring-boot:start -DskipTests  2>&1 | tee 'java21with3.2.liberica.spring-boot.log' &

sleep 10

pid=$(jps | grep 'HelloSpringApplication' | cut -d ' ' -f 1)
rss=$(ps -o rss= "$pid" | tail -n1)
mem_usage=$(bc <<< "scale=1; ${rss}/1024")
echo "The process was using ${mem_usage} megabytes"
echo "${mem_usage}" >> java21with3.2.liberica.spring-boot.log2

./mvnw spring-boot:stop -Dspring-boot.stop.fork

# Run optimized Spring Boot App JVM
cd target
jar -xf hello-spring-0.0.1-SNAPSHOT.jar

java -cp "BOOT-INF/classes:BOOT-INF/lib/*" dev.dashaun.kubed.spring.hello.hellospring.HelloSpringApplication > '../java21with3.2.liberica.java.log' &
cd ..

sleep 10

pid=$(jps | grep 'HelloSpringApplication' | cut -d ' ' -f 1)
rss=$(ps -o rss= "$pid" | tail -n1)
mem_usage=$(bc <<< "scale=1; ${rss}/1024")
echo "The process was using ${mem_usage} megabytes"
echo "${mem_usage}" >> 'java21with3.2.liberica.java.log2'

kill -9 $pid

# Run report

./stats.sh
