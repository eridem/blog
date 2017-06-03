#/bin/bash

JOBS=$(ls *.nomad)

for JOB in $JOBS; do

    nomad run $JOB

done
