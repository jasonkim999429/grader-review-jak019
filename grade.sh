CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

if [[ -f student-submission/ListExamples.java ]]
then
    echo "File found"
else
    echo "File not found"
    echo "Your score is 0 / 1"
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
    echo "Your score is 0 / 1"
    exit
else   
    echo "Compiled successfully"
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt

if grep -q "Tests run:" "junit-output.txt";
then
    OUTPUT=$(grep "Tests run:" junit-output.txt)
    FAILURES=$(echo "$OUTPUT" | cut -d" " -f6)
    TESTSRUN=$(echo "$OUTPUT" | cut -d"," -f1 | cut -d" " -f3)
    SUCCESS=$(( $TESTSRUN - $FAILURES ))
    echo "Your score is $SUCCESS / $TESTSRUN"
else
    OUTPUT=$(grep "OK" junit-output.txt)
    TESTSRUN=$(echo "$OUTPUT" | cut -d'(' -f2 | cut -d' ' -f1)
    echo "Your score is $TESTSRUN / $TESTSRUN"
fi


# grep exit codes
# 0     One or more lines were selected.
# 1     No lines were selected.
# >1    An error occurred.
