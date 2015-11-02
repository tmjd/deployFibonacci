#!/bin/bash -x

cd "$(dirname $0)"

apt-get install --yes git golang curl

rm -rf build
mkdir build
cd build

mkdir ./{bin,pkg,src}

export GOPATH=$(pwd)
export PATH=$GOPATH/bin:$PATH

go get github.com/tmjd/fibonacciServer
if [ $? -ne 0 ]; then
	echo "Failed getting fibonacciServer, please investigate"
	exit 1
fi

go test github.com/tmjd/fibonacci
if [ $? -ne 0 ]; then
	echo "Failed test fibonacci, please investigate"
	exit 1
fi
go test github.com/tmjd/fibonacciServer
if [ $? -ne 0 ]; then
	echo "Failed test fibonacciServer, please investigate"
	exit 1
fi

go install github.com/tmjd/fibonacciServer
if [ $? -ne 0 ]; then
	echo "Failed install of fibonacciServer, please investigate"
	exit 1
fi

cp bin/fibonacciServer /srv/salt/fibonacciServer/fibonacciServer

cd ..
./build/bin/fibonacciServer &
bash test_host.sh localhost 8080 fibonacci
if [ $? -ne 0 ]; then
    echo "Error: test_host.h localhost 8080 fibonacci"
    exit 1
fi
killall fibonacciServer

./build/bin/fibonacciServer --serve_path rest &
bash test_host.sh localhost 8080 rest
if [ $? -ne 0 ]; then
    echo "Error: test_host.sh localhost 8080 rest"
    exit 1
fi
killall fibonacciServer

./build/bin/fibonacciServer --serve_path rest --port 80 &
bash test_host.sh localhost 80 rest
if [ $? -ne 0 ]; then
    echo "Error: test_host.sh localhost 80 rest"
    exit 1
fi
killall fibonacciServer

./build/bin/fibonacciServer --port 80 &
bash test_host.sh localhost 80 fibonacci
if [ $? -ne 0 ]; then
    echo "Error: test_host.sh localhost 80 fibonacci"
    exit 1
fi
killall fibonacciServer
