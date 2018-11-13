# Adapted from https://github.com/SonarSource/docker-sonarqube/blob/master/7.1/Dockerfile
FROM openjdk:8

ENV SONAR_VERSION=7.4

# Http port
EXPOSE 9000

RUN groupadd -r sonarqube && useradd -r -g sonarqube sonarqube

RUN set -x \
    # pub   2048R/D26468DE 2015-05-25
    #       Key fingerprint = F118 2E81 C792 9289 21DB  CAB4 CFCA 4A29 D264 68DE
    # uid                  sonarsource_deployer (Sonarsource Deployer) <infra@sonarsource.com>
    # sub   2048R/06855C1D 2015-05-25
    && gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE \
    && cd /opt \
    && curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && curl -o sonarqube.zip.asc -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && mkdir sonarqube/extensions/downloads \
    && chown -R root:root sonarqube \
    && chown -R sonarqube:sonarqube sonarqube/data sonarqube/logs sonarqube/temp \
    && rm sonarqube.zip* \
    && rm -rf sonarqube/bin/* sonarqube/extensions/plugins/*

VOLUME "/opt/sonarqube/data"

WORKDIR /opt/sonarqube
RUN cd extensions/plugins && \
    curl -fsSL --remote-name-all \
        https://binaries.sonarsource.com/Distribution/sonar-java-plugin/sonar-java-plugin-5.9.1.16423.jar \
        https://binaries.sonarsource.com/Distribution/sonar-scm-git-plugin/sonar-scm-git-plugin-1.6.0.1349.jar

USER sonarqube
ENTRYPOINT java -jar lib/sonar-application-$SONAR_VERSION.jar -Dsonar.log.console=true
