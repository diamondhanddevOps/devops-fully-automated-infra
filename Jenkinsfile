def COLOR_MAP = [
    SUCCESS: 'good',
    FAILURE: 'danger'
]

pipeline {
    agent any

    stages {
        stage('Git checkout') {
            steps {
                echo 'Cloning project codebase...'
                git branch: 'main', url: 'https://github.com/shittua/devops-fully-automated-infra.git'
                sh 'ls'
            }
        }

        stage('Verify Terraform Version') {
            steps {
                echo 'verifying the terraform version...'
                sh 'terraform --version'
            }
        }

        stage('Terraform init') {
            steps {
                echo 'Initializing terraform project...'
                sh 'terraform init'
            }
        }

        stage('Terraform validate') {
            steps {
                echo 'Code syntax checking...'
                sh 'terraform validate'
            }
        }

        stage('Terraform plan') {
            steps {
                echo 'Terraform plan for the dry run...'
                sh 'terraform plan'
            }
        }

        // stage('Checkov scan') {
        //     steps {
        //         sh '''
        //         sudo pip3 install checkov
        //         checkov -s .
        //         '''
        //     }
        // }

        stage('Manual approval') {
            steps {
                input 'Approval required for deployment'
            }
        }

        stage('Terraform apply') {
            steps {
                echo 'Terraform apply...'
                sh 'terraform apply --auto-approve'
            }
        }
    }

    post {
        always {
            echo 'I will always say Hello again!'
            slackSend channel: '#Urgency-Dev', color: COLOR_MAP[currentBuild.currentResult.toString()], message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
        }
    }
}
