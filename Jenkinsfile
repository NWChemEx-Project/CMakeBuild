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
     	        module load python
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
	        	    module load python
	     	        cd build
	              	ctest -V
	     	        '''
            }
        }
    }
}
