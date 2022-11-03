#!/bin/bash


res=$(pwd)/sim_result
home=$(pwd)
sim=$(pwd)/sim-outorder

# Six benchmarks for hw4
tests=(apsi crafty gzip mcf parser swim)

mkdir -p $res

for bench in SPEC2000/spec2000args/*
do
	path=$bench
	bench=`basename $bench`
	if [[ ${tests[@]} =~ $bench ]]; then
		cd $path
		printf "Testing %s... " $bench
		./RUN$bench $sim ../../spec2000binaries/${bench}00.peak.ev6  -redir:sim $res/${bench}_result.txt -max:inst 10000000  > /dev/null
		cd $home
		echo "Done!"
	fi
done

