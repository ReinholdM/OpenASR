#!/bin/bash
source path.sh

expdir=$1
gpu=$2

# ep=avg-last1
ep=${3:?"avg-last10"}
decode_dir=$expdir/decode_test_${ep}
mkdir -p $decode_dir

CUDA_VISIBLE_DEVICES=$2 \
python -W ignore::UserWarning $SRC_ROOT/decode.py \
    --feed-batchsize 80 \
    --nbest 5 \
    --use_gpu True \
    $expdir/${ep}.pt \
    data/aishell1_train_chars.txt \
    data/test.json \
    $decode_dir/hyp.txt