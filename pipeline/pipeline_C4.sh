#!/bin/sh

#Name: parse.sh
#Usage: ./parse.sh <options> input_file
#Options: -c for conll-formatted files
#Purpose: parsing a Latin file in csts or conll format
#Prerequisites: Linux x64 os, Perl, Python, Java 
#Author: Edoardo Maria Ponti

BASEDIR=.
BINDIR=./bin
INPUT=./input
ICSTS=$INPUT/csts
ICONLL=$INPUT/conll

CONVERSION=true

while getopts ":c" opt; do
  case $opt in
    c)
      CONVERSION=false >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

if [ -z "$1" ]
then
    echo "Please specify a label for your test file."
    exit 1
fi

if [ $CONVERSION = true ]
then
  perl $BINDIR/csts2conll.pl $ICSTS/$1.csts $ICONLL/$1.conll
fi

TEST=$ICONLL/$1

echo "Input file acquired. Applying DeSR parsers #1 & #2."

TEMP=$BASEDIR/temporary
PAR=$BASEDIR/parsers
MwC=$BASEDIR/mod-and-conf

mkdir -p $TEMP

./$PAR/desr/src/desr -c $MwC/desr_mlp.conf -m $MwC/MLP_R-to-L.model $TEST.conll > $TEMP/$1-desr-dx-mlp.conll
./$PAR/desr/src/desr -c $MwC/desr_svm.conf -m $MwC/SVM_R-to-L.model $TEST.conll > $TEMP/$1-desr-svm.conll
./$PAR/desr/src/desr -c $MwC/desr_mlp.conf -m $MwC/MLP_L-to-R.model $TEST.conll > $TEMP/$1-desr-sx-mlp.conll

echo "DeSR parsers applied. Converting back and forth in conll09 format and applying MATE-tools parsers #1 & #2."

python $BINDIR/conllx_to_conll09.py $TEST.conll

java -Xmx6G -classpath $PAR/transition/transition-63.jar is2.transitionS2b.Parser -model $MwC/trans.model -test $TEST.conll09 -out $TEMP/$1-trans.conll09
java -Xmx4G -cp $PAR/anna/anna-3.61.jar is2.parser.Parser -model $MwC/mate-anna.mdl -test $TEST.conll09 -out $TEMP/$1-mateanna.conll09

python $BINDIR/conll09_to_conllx.py $TEMP/$1-trans.conll09
python $BINDIR/conll09_to_conllx.py $TEMP/$1-mateanna.conll09

rm $TEST.conll09

echo "MATE-tools parsers applied. Combining the outputs, evaluating conll result and converting in csts."

OUTPUT=./output
OCSTS=$OUTPUT/csts
OCONLL=$OUTPUT/conll

python $BINDIR/tree_combiner_no_weigth.py $TEMP/$1-desr-dx-mlp.conll $TEMP/$1-desr-svm.conll $TEMP/$1-desr-sx-mlp.conll $TEMP/$1-trans.conll $TEMP/$1-mateanna.conll > $OCONLL/$1-combined-C4.conll

python $BINDIR/conllx_evaluator.py $OCONLL/$1-combined-C4.conll $TEST.conll

if [ $CONVERSION = true ]
then
  perl $BINDIR/conll2csts.pl $OCONLL/$1-combined-C4.conll $ICSTS/$1.csts $OCSTS/$1-combined-C4.csts
fi

rm -r $TEMP

