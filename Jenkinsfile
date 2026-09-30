pipeline {
  agent any
  stages {
    stage('Compilar') {
      steps {
        sh 'docker build -t sitio-unidad1:${BUILD_NUMBER} .'
      }
    }
    stage('Escanear Imagen (Trivy)') {
      steps {
        sh 'trivy image --exit-code 1 --severity CRITICAL --quiet sitio-unidad1:${BUILD_NUMBER}'
      }
    }
    stage('Prueba') {
      steps {
        sh 'docker network create red-interna-web || true'
        sh 'docker rm -f test-sitio || true'
        sh 'docker run -d --name test-sitio --network red-interna-web --cap-drop=ALL --cap-add=NET_BIND_SERVICE -p 8082:80 sitio-unidad1:${BUILD_NUMBER}'
        sh 'sleep 3 && curl -f http://localhost:8082'
      }
      post {
        always {
          sh 'docker rm -f test-sitio || true'
        }
      }
    }
    stage('Desplegar') {
      steps {
        sh 'docker network create red-interna-web || true'
        sh 'docker rm -f sitio-unidad1 || true'
        sh 'docker run -d --name sitio-unidad1 --network red-interna-web --cap-drop=ALL --cap-add=NET_BIND_SERVICE -p 8081:80 sitio-unidad1:${BUILD_NUMBER}'
      }
    }
    stage('Escanear Red (Nmap)') {
      steps {
        sh '''
          nmap -p 8081 --open localhost | grep -q "8081/tcp open" \
          && echo "Puerto verificado correctamente: El servicio está activo y seguro" \
          || (echo "Error: El puerto esperado no está abierto o la red falló" && exit 1)
        '''
      }
    }
  }
}
