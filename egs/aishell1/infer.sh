#!/bin/bash
source path.sh

expdir=$1
model_type=$2
gpu=$3
ep=$4
decode_dir=$expdir/decode_test_${ep}
mkdir -p $decode_dir

CUDA_VISIBLE_DEVICES=$gpu \
python -W ignore::UserWarning $SRC_ROOT/infer.py \
    --batch_frames 140000 \
    --nbest 5 \
    --use_gpu True \
    --label_type tokens \
    $model_type \
    $expdir/${ep}.pt \
    data/aishell1_train_chars.txt \
    data/test.json \
    $decode_dir/hyp.txt
