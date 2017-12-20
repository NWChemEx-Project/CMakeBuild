pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
	            sh '''
		        set +x
	            source /etc/profile
  	            module load gcc/7.1.0-4bgguyp
     	        module load cmake
     	        cd NWChemExBase_Test
	            cmake -H. -Bbuild
	            cd build
	            make
	            '''
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'module
	  	        sh'''
		        set +x
     	        source /etc/profile
	            module load cmake
	            cd NWChemExBase_Test
	            cd build
	            ctest
	            '''
	            sh'''
	            set +x
	            source /etc/profile
	            cat NWChemExBase_Test/build/Testing/Temporary/LastTest.log
	            '''
            }
        }
    }
}
