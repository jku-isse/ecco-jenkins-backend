def dockerImage
pipeline {
    agent {label "jenkins"}
    
    stages {
        stage("Pull") {
            steps {
                dir('forDocker') {
                    checkout changelog: true,
                    poll: true,
                    scm: [$class: 'GitSCM', branches: [[name: '*/master']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    submoduleCfg: [],
                    userRemoteConfigs: [[credentialsId: 'git', url: 'https://github.com/Dorkat0/ecco.git']]]
                }
            }
        }
        
        stage("Create Docker") {
            steps {
                script {
                    sh 'chmod -R 777 forDocker/'
                    dockerImage = docker.build("ecco-backend:${env.BUILD_ID}")
                }   
            }
        }
        
        stage("Build") {
            steps {
                script {
                    dockerImage.inside('-v $WORKSPACE/serverRepositories:/media/serverRepositories'){
                        sh 'gradle -g gradle-user-home -b /home/gradle/rest/build.gradle build'
                    }
                }
            }
        }
        
        stage("Test") {
            steps {
                script {
                    dockerImage.inside('-v $WORKSPACE/serverRepositories:/media/serverRepositories'){
                      sh 'gradle -g gradle-user-home -b  /home/gradle/rest/build.gradle test'
                    }
                }
            }
        }
        
        stage("Publish") {
            steps {
                input "Do you want to deploy?"
                script {
                    withDockerRegistry([credentialsId: "DockerHubCredentials", url:""]) {
                        sh "docker tag ecco-backend:${env.BUILD_ID} bergthalerjku/ecco_backend:${env.BUILD_ID}"
                        sh "docker push bergthalerjku/ecco_backend:${env.BUILD_ID}"
                        
                        sh "docker tag ecco-backend:${env.BUILD_ID} bergthalerjku/ecco_backend:latest"
                        sh "docker push bergthalerjku/ecco_backend:latest"
                    }
                }
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: 'forDocker/rest/build/reports/test/*', fingerprint: false
            publishHTML (target : [
                allowMissing: false,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'forDocker/rest/build/reports/test',
                reportFiles: '*.html',
                reportName: 'Report',
                reportTitles: ''])
        }
    }
}
