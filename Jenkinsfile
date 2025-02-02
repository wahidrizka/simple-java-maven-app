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
}
