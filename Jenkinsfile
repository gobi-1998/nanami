pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                // Navigate to the directory where your Terraform script is located
                dir('path/to/nanami') {
                    // Initialize Terraform
                    script {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                // Navigate to the directory where your Terraform script is located
                dir('path/to/nanami') {
                    // Apply Terraform changes (you may need to provide any necessary variables)
                    script {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            steps {
                // Navigate to the directory where your Terraform script is located
                dir('path/to/nanami') {
                    // Destroy Terraform resources (optional, only if needed)
                    script {
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }
}

