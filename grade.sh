CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

if [[ -f student-submission/ListExamples.java ]]
then
    echo "File found"
else
    echo "File not found"
    exit
fi

cp TestListExamples.java grading-area
cp student-submission/ListExamples.java grading-area
cp -r lib grading-area

cd grading-area
javac -cp $CPATH *.java
if [[ $? -ne 0 ]]
then 
    echo "Did not compile successfully"
    exit
else   
    echo "Compiled successfully"
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt
grep "Tests run:" junit-output.txt > results.txt
FAILURES=$(cut -d" " -f 6 results.txt)
cut -d" " -f 3 results.txt > testsrun.txt
TESTSRUN=$(cut -d"," -f 1 testsrun.txt)
SUCCESS=$(($TESTSRUN - $FAILURES))
echo "Your score is $SUCCESS / $TESTSRUN"



# grep exit codes
# 0     One or more lines were selected.
# 1     No lines were selected.
# >1    An error occurred.