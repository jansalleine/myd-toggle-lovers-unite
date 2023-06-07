#!/bin/sh
rm -rf *.prg;
rm -rf *.bin;
rm -rf *.exo;
for i in *.sid; do
    [ -f "$i" ] || break
    FILENAME="${i%%.*}.bin";
    dd if=$i of=$FILENAME bs=1 skip=124;
    EXONAME="${i%%.*}.exo";
    exomizer3 mem -l 0xc000 -f -o $EXONAME $FILENAME;
    psid64 -c -t blue -p "/home/spider/C64/tools/sidplay26w/sidid.cfg" -v $i;
done
cp -f -v *.exo ../exo/
