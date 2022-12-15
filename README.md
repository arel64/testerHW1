# testerHW1

Clone Repo, Drag kmeans.c into the same directoy as t.sh  
run:  
chmod +x t.sh  
./t.sh  

Valid Output Example:  
Test Success InvalidClusterLow1.txt  
Test Success InvalidClusterHigh1.txt  
Test Success InvalidClusterWithIter1.txt  
Test Success InvalidClusterWithValidIter1.txt  
Test Success InvalidIter1.txt  
Test Success InvalidIterHigh1.txt  
Test Success InvalidIterHighNonNum1.txt  
Test Success InvalidClusterNonNum1.txt  
Test Success InvalidClusterLow2.txt  
Test Success InvalidClusterHigh2.txt  
Test Success InvalidClusterWithIter2.txt  
Test Success InvalidClusterWithValidIter2.txt  
Test Success InvalidIter2.txt  
Test Success InvalidIterHigh2.txt  
Test Success InvalidIterHighNonNum2.txt  
Test Success InvalidClusterNonNum2.txt  
Test Success Valid1.txt  
Test Success Valid2.txt  
Test Success Valid3.txt  
Good Output 1  
Good Output 2  
Good Output 3  

Any other output should be considered invalid  

Features:  
* Checks many edge cases for input and whether valgrind detects leaked memory for it, This includes ~20 tests for
* Valid Runs with 3 parameters
* Valid Runs with 2 parameters
* Invalid Runs with 2 paramters
* Invalid Runs with 3 parameters
* Any leaked memory will result in test fail

* This will also check that all 3 inputs provided return the output provided
* This program checks the error codes for valgrind, which means tests will fail if you leak memory in any way
* This script generates valgrind logs for each test, look at the /logs folder for specific errors
* Maybe something else I forgot

Limitations:  
* If you return 1 but return an incorrect error message(for example typo in the error cluster message and return 1) the test will falsly pass.
* Maybe something else I forgot


******
Use at you own risk, I can't say for sure this will work or detect any bugs
******