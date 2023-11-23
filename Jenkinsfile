def dockerImage
pipeline {
    agent {label "jenkins"}
    
    stages {
        stage("Pull") {
            steps {
                dir('forDocker') {
                    checkout changelog: false,
                    poll: true,
                    scm: [$class: 'GitSCM', branches: [[name: '*/Master']],
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
                    dockerImage = docker.build("ecco-backend:${env.BUILD_ID}")
                }   
            }
        }
        
        stage("Build") {
            steps {
                script {
                    dockerImage.inside('-v $WORKSPACE/serverRepositories:/media/serverRepositories'){
                        sh 'gradle -g gradle-user-home -b forDocker/rest/build.gradle build'
                    }
                }
            }
        }
        
        stage("Test") {
            steps {
                script {
                    dockerImage.inside('-v $WORKSPACE/serverRepositories:/media/serverRepositories'){
                      sh 'gradle -g gradle-user-home -b forDocker/rest/build.gradle test'
                    }
                }
            }
        }

    }
}
