pipeline {
    agent any

    stages {
        stage('Terraform Init') {
            steps {
                // Navigate to the directory where your Terraform script is located
                dir('proj.tf') {
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                // Navigate to the directory where your Terraform script is located
                dir('proj.tf') {
                    // Apply Terraform changes (you may need to provide any necessary variables)
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Terraform Destroy') {
            steps {
                // Navigate to the directory where your Terraform script is located
                dir('proj.tf') {
                    // Destroy Terraform resources (optional, only if needed)
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}
