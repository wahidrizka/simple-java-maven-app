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
                scp -o StrictHostKeyChecking=no target/my-app-1.0-SNAPSHOT.jar ec2-user@18.141.145.155:/home/ec2-user/app
            '''
            // Jalankan aplikasi di EC2 (ganti "yourapp.jar" dengan nama file JAR yang sesuai)
            sh '''
                ssh -o StrictHostKeyChecking=no ec2-user@18.141.145.155 "nohup java -jar /home/ec2-user/app/my-app-1.0-SNAPSHOT.jar 2>&1 | tee /home/ec2-user/app/app.log &"
            '''
        }
    }
}
