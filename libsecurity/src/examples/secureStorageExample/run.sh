#!/bin/bash

code=(
   "utils" "storage"
)

c1=`pwd`
for c in "${code[@]}"
do
	pushd . >& /dev/null
	cd ../../$c
	make clean
	make STATIC_F=-DSTATIC_F
	popd >& /dev/null
done

cd $c1
make clean
make STATIC_F=-DSTATIC_F

./secureStorageUsage

make clean
