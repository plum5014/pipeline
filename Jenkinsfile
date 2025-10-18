pipeline {
  agent any
  tools { nodejs 'nodejs' }   // Manage Jenkins > Global Tool Configuration에서 등록한 이름

  stages {
    stage('Prepare') {
      steps {
        bat 'if not exist newman mkdir newman'
      }
    }

    stage('Install Newman') {
      steps {
        bat 'npm install -g newman newman-reporter-htmlextra'
      }
    }

    stage('Run Postman Collections') {
      steps {
        // 환경/컬렉션 파일이 리포지토리 루트에 있다고 가정
        bat 'newman run Login_API_Test.postman_collection.json -e GameQA_ENV.postman_environment.json -r cli,htmlextra --reporter-htmlextra-export newman\\Login_Report.html --export-environment GameQA_ENV.postman_environment.json'
        bat 'newman run Ranking_API_Test.postman_collection.json -e GameQA_ENV.postman_environment.json -r cli,htmlextra --reporter-htmlextra-export newman\\Ranking_Report.html'
        bat 'newman run Item_Grant_API_Test.postman_collection.json -e GameQA_ENV.postman_environment.json -r cli,htmlextra --reporter-htmlextra-export newman\\ItemGrant_Report.html'
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'newman/*.html', fingerprint: true
      // HTML Publisher 플러그인이 설치되어 있다면 아래 주석 해제
      publishHTML(target: [
      reportDir: 'newman',
      reportFiles: 'Login_Report.html,Ranking_Report.html,ItemGrant_Report.html',
      reportName: 'Newman Reports',
      keepAll: true,
      alwaysLinkToLastBuild: true
       ])
    }
  }
}
