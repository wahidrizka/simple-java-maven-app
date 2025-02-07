node {
    def mvnHome = tool name: 'Maven'
    
    stage('Checkout') {
        cleanWs()
        checkout scm
    }

    stage('Build') {
        sh "'${mvnHome}/bin/mvn' -B -DskipTests clean package"
    }

    stage('Test') {
        sh "'${mvnHome}/bin/mvn' test"
        junit 'target/surefire-reports/*.xml'
    }

    stage('Manual Approval') {
        input message: 'Lanjutkan ke tahap Deploy?', ok: 'Proceed'
    }

    stage('Deploy') {
        sshagent(['9dcfb994-e247-45ab-af64-9c7b51df5acc']) {
            sh '''
                # Kirim file hasil build ke EC2
                scp -o StrictHostKeyChecking=no target/my-app-1.0-SNAPSHOT.jar ec2-user@18.141.145.155:/home/ec2-user/app/
                scp -o StrictHostKeyChecking=no ${WORKSPACE}/Dockerfile ec2-user@18.141.145.155:/home/ec2-user/app/

                # SSH ke EC2 untuk membangun dan menjalankan container
                ssh -o StrictHostKeyChecking=no ec2-user@18.141.145.155 "
                    cd /home/ec2-user/app;

                    # Memastikan Docker sudah terinstal
                    if ! command -v docker &> /dev/null; then
                        sudo yum update -y;
                        sudo yum install docker -y;
                        sudo systemctl start docker;
                        sudo systemctl enable docker;
                        sudo usermod -aG docker ec2-user;
                    fi;

                    newgrp docker;

                    # Stop dan remove container lama jika ada
                    docker stop simple-java-maven-app-container || true;
                    docker rm simple-java-maven-app-container || true;

                    # Hapus image lama untuk mencegah konflik
                    docker rmi simple-java-maven-app:latest || true;

                    # Build container
                    docker build -t simple-java-maven-app:latest .

                    # Jalankan container baru
                    docker run -d --name simple-java-maven-app-container -p 8080:8080 simple-java-maven-app:latest;

                    # Tampilkan log sementara
                    sleep 5;
                    docker logs simple-java-maven-app-container --tail 10;

                    # Jeda eksekusi pipeline selama 1 menit
                    echo "Menunggu 1 menit sebelum pipeline selesai..."
                    sleep 60
                "
            '''
        }
    }
}
