pipeline {
    agent any

    environment {
        IMAGE_NAME = "aaryaj/argo-cd"
        IMAGE_TAG  = "${BUILD_NUMBER}"
        GIT_REPO   = "github.com/ErebusAJ/git-ops-argo-cd.git"
    }

    stages {

        stage('CI Pipeline') {

            when {
                not {
                    changelog '.*Update image.*'
                }
            }

            stages {

                stage('Checkout') {
                    steps {
                        checkout scm
                    }
                }

                stage('Build Backend Image') {
                    steps {
                        dir('backend') {
                            sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
                        }
                    }
                }

                stage('Push Image') {
                    steps {
                        withCredentials([usernamePassword(
                            credentialsId: 'dockerhub-creds',
                            usernameVariable: 'DOCKER_USER',
                            passwordVariable: 'DOCKER_PASS'
                        )]) {
                            sh '''
                                echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                                docker push $IMAGE_NAME:$IMAGE_TAG
                            '''
                        }
                    }
                }

                stage('Update Manifest') {
                    steps {
                        sh """
                        sed -i 's|image:.*|image: $IMAGE_NAME:$IMAGE_TAG|' kubernetes/deployment.yaml
                        """
                    }
                }

                stage('Commit & Push Changes') {
                    steps {
                        withCredentials([usernamePassword(
                            credentialsId: 'github-creds',
                            usernameVariable: 'GIT_USER',
                            passwordVariable: 'GIT_PASS'
                        )]) {
                            sh '''
                                git config user.email "jenkins@ci.local"
                                git config user.name "jenkins"

                                git add k8s/deployment.yaml
                                git commit -m "Update image to $IMAGE_TAG [skip ci]" || echo "No changes"

                                git push https://$GIT_USER:$GIT_PASS@$GIT_REPO HEAD:main
                            '''
                        }
                    }
                }

            }
        }
    }
}