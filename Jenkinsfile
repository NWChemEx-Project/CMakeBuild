pipeline {
    agent any
    options {
        skipDefaultCheckout true
    }
    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir()
                checkout scm
            }
        }
        stage('Build') {
            steps {
                echo 'Building...'
	            sh '''
    		    set +x
	            source /etc/profile
  	            module load gcc/7.1.0
     	        module load cmake
     	        module load mvapich2
     	        module load python/3.6.2-q2qwvks
	            cmake -H. -Bbuild
	            cd build
	            make
	            '''
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
	  	        sh'''
		        set +x
     	          	source /etc/profile
			        module load gcc/7.1.0
	        	    module load cmake
	        	    module load python/3.6.2-q2qwvks
	     	        cd build
	              	ctest -V
	     	        '''
            }
        }
    }
}
