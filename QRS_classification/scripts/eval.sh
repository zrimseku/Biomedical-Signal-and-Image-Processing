#!/bin/bash
#Run algorithm in Matlab. Output should be annotations in text files 
#with WFDB annotator structure.See Matlab frame on the webclassroom.
[ -e eval1.txt ] && rm eval1.txt
[ -e eval2.txt ] && rm eval2.txt

FILES=*.dat

for f in $FILES
do
  f=$(basename $f)
  f=${f%.*}
  echo  $f #evaluate using reference annotations .fatr and your annotations .cls
  wrann -r $f -a qrs < $f".asc" #convert text annotator to WFDB format
  bxb -r $f -a fatr qrs -l eval1.txt eval2.txt 
done
sumstats eval1.txt eval2.txt > results.txt #final statistics