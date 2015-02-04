#!/bin/bash
scriptDir="$( cd "$( dirname "$0" )" && pwd )";
bash $@ $scriptDir/test.sh | less -R


