#!/bin/bash

set -o errexit
set -o nounset

echo "##### SETUP #############################################################"

bash bench-profiling-polybench4.sh         compile-libraries
bash bench-profiling-rodinia-sequential.sh compile-libraries

echo "##### ALIAS PROFILE #####################################################"

bash bench-profiling-polybench4.sh         aa-profile
bash bench-profiling-rodinia-sequential.sh aa-profile

echo "##### STATIC EVAL #######################################################"

bash bench-profiling-polybench4.sh         aa-eval 2>&1 | tee polybench4.aa-eval
bash bench-profiling-rodinia-sequential.sh aa-eval 2>&1 | tee rodinia.aa-eval

echo "##### SCEV ONLY #########################################################"

export ALIAS_CHECK_FLAGS=(
	-mllvm -polly-use-scev-alias-checks
	-mllvm -polly-use-must-alias-checks
)

bash bench-profiling-polybench4.sh         benchmark | tee polybench4.scev.log
bash bench-profiling-rodinia-sequential.sh benchmark | tee rodinia.scev.log

bash bench-profiling-polybench4.sh         eval-check-costs | tee polybench4.check-costs.scev.log
bash bench-profiling-rodinia-sequential.sh eval-check-costs | tee rodinia.check-costs.scev.log

echo "##### HEAP ONLY #########################################################"

export ALIAS_CHECK_FLAGS=(
	-mllvm -polly-use-heap-alias-checks
	-mllvm -polly-use-must-alias-checks
)

bash bench-profiling-polybench4.sh         benchmark | tee polybench4.heap.log
bash bench-profiling-rodinia-sequential.sh benchmark | tee rodinia.heap.log

bash bench-profiling-polybench4.sh         eval-check-costs | tee polybench4.check-costs.heap.log
bash bench-profiling-rodinia-sequential.sh eval-check-costs | tee rodinia.check-costs.heap.log

echo "##### BOTH SCEV AND HEAP ################################################"

export ALIAS_CHECK_FLAGS=(
	-mllvm -polly-use-scev-alias-checks
	-mllvm -polly-use-heap-alias-checks
	-mllvm -polly-use-must-alias-checks
)

bash bench-profiling-polybench4.sh         benchmark | tee polybench4.both.log
bash bench-profiling-rodinia-sequential.sh benchmark | tee rodinia.both.log

bash bench-profiling-polybench4.sh         eval-check-costs | tee polybench4.check-costs.both.log
bash bench-profiling-rodinia-sequential.sh eval-check-costs | tee rodinia.check-costs.both.log
