node {
    def mvnHome = tool name: 'Maven'

    stage('Build') {
        sh "'${mvnHome}/bin/mvn' -B -DskipTests clean package"
    }

    stage('Test') {
        sh "'${mvnHome}/bin/mvn' test"

        // Post-test actions
        junit 'target/surefire-reports/*.xml'
    }
    stage('Deploy') {
        // Menggunakan kredensial SSH yang sudah dikonfigurasi dengan ID '9dcfb994-e247-45ab-af64-9c7b51df5acc'
        sshagent(['9dcfb994-e247-45ab-af64-9c7b51df5acc']) {
            // Copy file JAR dari direktori target ke instance EC2
            sh '''
                scp -o StrictHostKeyChecking=no target/*.jar ec2-user@18.141.145.155:/app
            '''
            // Jalankan aplikasi di EC2 (ganti "yourapp.jar" dengan nama file JAR yang sesuai)
            sh '''s
                ssh -o StrictHostKeyChecking=no ec2-user@18.141.145.155 "nohup java -jar /app/simplemavenapp.jar > /dev/null 2>&1 &"
            '''
        }
    }
}
