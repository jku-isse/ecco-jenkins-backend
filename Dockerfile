FROM gradle:8.3-jdk20
 
RUN apt-get update && \
    apt-get install git
COPY ./forDocker/ /home/gradle
RUN chmod -R 777 /home/gradle/
    
LABEL maintainer=”Bergthaler”
LABEL version=”1.0”
LABEL description=”Linux_Ecco_System”
EXPOSE 8081
CMD gradle -b rest/build.gradle run
