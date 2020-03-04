#!/bin/bash

if [ ! -d "./tests" ]; then
    echo "Error: tests directory not found!"
    exit 1
fi

if [ ! -e "./a.out" ]; then
    echo "Error: a.out not found!"
    exit 1
fi

if [ ! -x "./a.out" ]; then
    echo "Error: a.out not executable!"
    exit 1
fi

let count=0
let all=0

mkdir -p ./output



    
    for test_file in $(find ./tests -type f -name "*.txt" | sort); do
    echo
    echo "$test_file"
    echo
    echo "input: "
    cat ${test_file}
    echo
    for taskNumber in 1 2 3 4 5; do
        echo "Task #$taskNumber"
        all=$((all+1))
        name=`basename ${test_file} .txt`
        expected_file=${test_file}.expected${taskNumber}
        output_file=./output/${name}.output
        diff_file=./output/${name}.diff
        ./a.out ${taskNumber} < ${test_file} > ${output_file}
        diff -Bw ${expected_file} ${output_file} > ${diff_file}
        
        if [ -s ${diff_file} ]; then
            echo "${name}: Output does not match expected:"
            echo "--------------------------------------------------------"
            echo "output: "
            cat ${output_file}
            echo "expected: "
            cat ${expected_file}
            echo ""
            # cat ${diff_file}
        else
            count=$((count+1))
            echo "OK"
           
            echo "output: "
            cat ${output_file}
            echo
            echo "--------------------------------------------------------"
            echo
        fi
        
        rm -f ${output_file}
        rm -f ${diff_file}
    done
    echo "========================================================"
done


echo
echo "Passed $count tests out of $all for all tasks"
echo

rmdir ./output
