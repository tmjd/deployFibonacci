#!/bin/bash


host=localhost
port=8080
path=fibonacci

if [ $# -eq 3 ]; then
    host=$1
    port=$2
    path=$3
elif [ $# -eq 2 ]; then
    host=$1
    port=$2
elif [ $# -eq 1 ]; then
    host=$1
fi

curl_opts='--fail --silent --show-error'

result="$(curl $curl_opts --data n=10 http://$host:$port/$path 2>&1)"
if [ "$result" != "[0,1,1,2,3,5,8,13,21,34]" ]; then
    echo "ERROR n=10 did not have correct output with POST method"
fi

result="$(curl $curl_opts --form n=8 http://$host:$port/$path 2>&1)"
if [ "$result" != "[0,1,1,2,3,5,8,13]" ]; then
    echo "ERROR n=8 did not have correct output with POST method as form"
fi

result="$(curl $curl_opts http://$host:$port/$path?n=20 2>&1)"
if [ "$result" != "[0,1,1,2,3,5,8,13,21,34,55,89,144,233,377,610,987,1597,2584,4181]" ]; then
    echo "ERROR n=20 did not have correct output with GET method"
fi

result="$(curl $curl_opts http://$host:$port/$path?n=0 2>&1)"
if [ "$result" != "[]" ]; then
    echo "ERROR n=0 did not have correct output with GET method"
fi

result="$(curl $curl_opts http://$host:$port/$path?n=-3 2>&1)"
if [ $? -eq 0 ]; then
    echo "ERROR n=-3 did not have correct output from negative"
fi
if [[ $result =~ 400 ]]; then
    /bin/true
else
    echo "ERROR Code from n=-3 was not a 400. $result"
fi

result="$(curl $curl_opts http://$host:$port/$path?n=-0 2>&1)"
if [ $? -ne 0 -a "$result" == "[]" ]; then
    echo "ERROR n=-0 should be successful"
fi

result="$(curl $curl_opts http://$host:$port/$path/nothing?n=4 2>&1)"
if [ $? -ne 0 -a "$result" == "[0,1,1,2]" ]; then
    echo "ERROR with additional url path expect failure"
fi
