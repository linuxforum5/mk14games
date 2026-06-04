#!/bin/sh
BASENAME=ledMatchOctal
ASMFILE=main.asm
OBASE=$BASENAME-lf12-gf12
OUT=$OBASE.hex
ROOTDIR=../..
$ROOTDIR/utils/sbasm/sbasm3/sbasm $ASMFILE > $OUT.lst 2> $OUT.err

if [ -e $OUT ] ; then
    if [ ! -s $OUT.err ] ; then
        rm $OUT.err
        objcopy --input-target=ihex --output-target=binary $OBASE.hex $OBASE.bin
        cat $OUT # | wl-copy
#        rm $OUT
        wl-copy < $OBASE.hex
        FRQ=3000
        $ROOTDIR/utils/mk14utils/bin/mk14bin2wav -b $FRQ -p 500 $OBASE.bin
        echo "OK"
        $ROOTDIR/emu/MK14_Emulator_python/MK14.py $OBASE.hex &
    else
        echo "ASM HIBA:"
        cat $OUT.err
    fi
else
    echo "HIBA!!!"
fi
