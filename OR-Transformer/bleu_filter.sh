#!/bin/bash

if [ $# -ne 3 ]; then
    echo "usage: $0 [model-out-file] [refence-file] [threshold]"
    echo "usage: $0 trans.out ref.en 80.00"
    exit
fi


MODELOUT=$1
REFERENCE=$2
THRESHOLD=$3

MODEL_FILTER=model_out.filter
REFERENCE_FILTER=reference.filter

SRCLANG=$(echo $LANGPAIR | cut -d '-' -f 1)
TGTLANG=$(echo $LANGPAIR | cut -d '-' -f 2)


TMP_REF=$(mktemp)
TMP_MODEL_OUT=$(mktemp)

sed -r 's/(@@ )|(@@ ?$)//g' $REFERENCE > $TMP_REF
sed -r 's/(@@ )|(@@ ?$)//g' $MODELOUT > $TMP_MODEL_OUT
TMP_BLEU=$(mktmp)
python score.py --ref $TMP_REF --sentence-bleu < $TMP_MODEL_OUT > $TMP_BLEU
sed -i '1d' $TMP_BLEU
TMP_COMBINE_MODEL=$(mktmp)
TMP_COMBINE_REF=$(mktmp)
paste $TMP_BLEU $TMP_MODEL_OUT > $TMP_COMBINE_MODEL
paste $TMP_BLEU $TMP_MODEL_OUT > $TMP_COMBINE_REF
cat $TMP_COMBINE_MODEL | awk -F"[ ,]" '$4>='+$THRESHOLD | cut -f2- > $MODEL_FILTER
cat $TMP_COMBINE_REF | awk -F"[ ,]" '$4>='+$THRESHOLD | cut -f2- > $REFERENCE_FILTER

rm -f $TMP_REF