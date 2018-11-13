# Reproducer for a SonarQube bug involving SonarJava 5.9.1

## Prerequisites

- Docker
- JDK 8

## Set up

Build the Docker image of SonarQube with a few plugins:

    docker build -t sonarqube:s4248-npe .

Run a SonarQube container:

    docker run --rm -p 9000:9000 --name sonarqube sonarqube:s4248-npe

Once SonarQube is up:

1. Open http://localhost:9000/sessions/new?return_to=%2Fprofiles
1. Log in as `admin` / `admin`
1. Skip the tutorial
1. Create a new "Test" quality profile, then set it as the default quality profile
1. Go to http://localhost:9000/coding_rules?open=squid%3AS4248&q=S4248 and activate the S4248 rule on the quality profile

## Run the analysis on the project

    ./gradlew sonarqube --stacktrace

## Stop the SonarQube container

    docker stop sonarqube

-----

Licensed under the LGPL 3.
