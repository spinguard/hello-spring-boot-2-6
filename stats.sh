function startupTime() {
  echo "$(sed -nE 's/.* in ([0-9]+\.[0-9]+) seconds.*/\1/p' < $1)"
}

clear

echo "Comparison of memory usage and startup times"
echo ""

# Headers
printf "%-35s %-25s %-15s %s\n" "Configuration" "Startup Time (seconds)" "(MB) Used" "(MB) Savings"
echo "--------------------------------------------------------------------------------------------"

# Spring Boot 2.6 with Java 8
#STARTUP1=$(sed -nE 's/.* in ([0-9]+\.[0-9]+) seconds.*/\1/p' < ./java8with2.6.log)
#STARTUP1=$(grep -o 'Started HelloSpringApplication in .*' < ./java8with2.6.log)
MEM1=$(cat ./java8with2.6.spring-boot.log2)
printf "%-35s %-25s %-15s %s\n" "Spring Boot 2.6 with Java 8" "$(startupTime './java8with2.6.spring-boot.log')" "$MEM1" "-"

# Spring Boot 3.2 with Java 21
#STARTUP2=$(grep -o 'Started HelloSpringApplication in .*' < ./java21with3.2.log)
MEM2=$(cat ./java21with3.2.spring-boot.log2)
PERC2=$(bc <<< "scale=2; 100 - ${MEM2}/${MEM1}*100")
printf "%-35s %-25s %-15s %s \n" "Spring Boot 3.2 with Java 21" "$(startupTime './java21with3.2.spring-boot.log')" "$MEM2" "$PERC2%"

# Spring Boot 3.2 with Java 21 Liberica
#STARTUP2=$(grep -o 'Started HelloSpringApplication in .*' < ./java21with3.2.liberica.log)
MEM2=$(cat ./java21with3.2.liberica.spring-boot.log2)
PERC2=$(bc <<< "scale=2; 100 - ${MEM2}/${MEM1}*100")
printf "%-35s %-25s %-15s %s \n" "Spring Boot 3.2 with Java 21 Liberica" "$(startupTime './java21with3.2.liberica.spring-boot.log')" "$MEM2" "$PERC2%"

# Spring Boot 3.2 with Java 21 Liberica - Java startup
#STARTUP2=$(grep -o 'Started HelloSpringApplication in .*' < ./java21with3.2.liberica.log)
MEM2=$(cat ./java21with3.2.liberica.java.log2)
PERC2=$(bc <<< "scale=2; 100 - ${MEM2}/${MEM1}*100")
printf "%-35s %-25s %-15s %s \n" "Spring Boot 3.2 with Java 21 Liberica - Java startup" "$(startupTime './java21with3.2.liberica.java.log')" "$MEM2" "$PERC2%"

# Spring Boot 3.2 with AOT processing, native image
#STARTUP3=$(grep -o 'Started HelloSpringApplication in .*' < ./nativeWith3.2.log)
MEM3=$(cat ./nativeWith3.2.log2)
PERC3=$(bc <<< "scale=2; 100 - ${MEM3}/${MEM1}*100")
printf "%-35s %-25s %-15s %s \n" "Spring Boot 3.2 with AOT, native" "$(startupTime './nativeWith3.2.log')" "$MEM3" "$PERC3%"

echo "--------------------------------------------------------------------------------------------"

