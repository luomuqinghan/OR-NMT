
# OR-NMT: Bridging the Gap between Training and Inference for Neural Machine Translation

> Wen Zhang, Yang Feng, Fandong Meng, Di You and Qun Liu. Bridging the Gap between Training and Inference for Neural Machine Translation. In Proceedings of ACL, 2019. [\[paper\]](https://www.aclweb.org/anthology/P19-1426.pdf)[\[code\]](https://github.com/ictnlp/OR-NMT)

Codes in the two directories are the OR-NMT systems based on the RNNsearch and Transformer models correspondingly
+ OR-RNNsearch: based on the RNNsearch system which we implemented from scratch
+ OR-Transformer: based on the Transformer system [fairseq](https://github.com/pytorch/fairseq) implemented by Facebook

## Runtime Environment
This system has been tested in the following environment.
+ OS: Ubuntu 16.04.1 LTS 64 bits
+ Python version \>=3.6
+ Pytorch version \>=1.2

For OR-Transformer:

First, go into the OR-Transformer directory.

Then, the training script is the same with fairseq, except for the following arguments:
- add `--use-word-level-oracles` for training Transformer by word-level oracle.
- add `--use-sentence-level-oracles` for training Transformer by sentence-level oracle.

By default, the probability is decayed based on the update index.
- add `--use-epoch-numbers-decay` for decaying based on the epoch index.
- the hyper-parameter `--decay-k` is used to control the speed of the inverse sigmoid decay.
  - set `8~15` for the decaying based on epoch index
  - set `3000~8000` for the decaying based on update index
  - The larger the value, the slower the decay, vice versa.

Gumbel noise:
- add `--use-greed-gumbel-noise` to sample word-level oracle with gumbel noise
- add `--use-bleu-gumbel-noise` to sample sentence-level oracle with gumbel noise
- `--gumbel-noise` is used as the hyper-parameter in the calculation of Gumbel noise
- `--oracle-search-beam-size` is used to set the beam size in length-constrained decoding


Example of the script for word-level training and decaying the probability based on epoch index:
```shell
export CUDA_VISIBLE_DEVICES=0,1,2,3
batch_size=4096
accum=2
data_dir=directory_of_data_bin
model_dir=./ckpt
python train.py $data_dir \
    --arch transformer_vaswani_wmt_en_de_big --share-all-embeddings \
    --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 --lr-scheduler inverse_sqrt \
    --warmup-init-lr 1e-07 --warmup-updates 4000 --lr 0.0005 --min-lr 1e-09 \
    --weight-decay 0.0 --criterion label_smoothed_cross_entropy --label-smoothing 0.1 \
    --max-tokens $batch_size --update-freq $accum --no-progress-bar --log-format json --max-update 200000 \
    --log-interval 10 --save-interval-updates 10000 --keep-interval-updates 10 --save-interval 10000 \
    --seed 1111 --skip-invalid-size-inputs-valid-test \
    --distributed-port 28888 --distributed-world-size 4 --ddp-backend=no_c10d \
    --source-lang en --target-lang de --save-dir $model_dir \
	--use-word-level-oracles --use-epoch-numbers-decay --decay-k 10 | tee -a $model_dir/training.log
```

## NOTE
+ The speed of word-level training is almost the same as original transformer.
+ Sentence-level training is slower than word-level training.
+ The arguments use-epoch-numbers-decay and decay-k need to be adjusted on different training data.

## Citation
please cite as:
```bibtex
@inproceedings{zhang2019bridging,
    title = "Bridging the Gap between Training and Inference for Neural Machine Translation",
    author = "Zhang, Wen and Feng, Yang and Meng, Fandong and You, Di and Liu, Qun",
    booktitle = "Proceedings of the 57th Annual Meeting of the Association for Computational Linguistics",
    month = jul,
    year = "2019",
    address = "Florence, Italy",
    publisher = "Association for Computational Linguistics",
    url = "https://www.aclweb.org/anthology/P19-1426",
    doi = "10.18653/v1/P19-1426",
    pages = "4334--4343",
}
```

<p align="center">
  <img src="./OR-Transformer/fairseq_logo.png" width="150">
  <br />
  <br />
  <a href="https://github.com/pytorch/fairseq/blob/master/LICENSE"><img alt="MIT License" src="https://img.shields.io/badge/license-MIT-blue.svg" /></a>
  <a href="https://github.com/pytorch/fairseq/releases"><img alt="Latest Release" src="https://img.shields.io/github/release/pytorch/fairseq.svg" /></a>
  <a href="https://github.com/pytorch/fairseq/actions?query=workflow:build"><img alt="Build Status" src="https://github.com/pytorch/fairseq/workflows/build/badge.svg" /></a>
  <a href="https://fairseq.readthedocs.io/en/latest/?badge=latest"><img alt="Documentation Status" src="https://readthedocs.org/projects/fairseq/badge/?version=latest" /></a>
</p>

--------------------------------------------------------------------------------

Fairseq(-py) is a sequence modeling toolkit that allows researchers and
developers to train custom models for translation, summarization, language
modeling and other text generation tasks.

### What's New:

- March 2020: [Byte-level BPE code released](examples/byte_level_bpe/README.md)
- February 2020: [mBART model and code released](examples/mbart/README.md)
- February 2020: [Added tutorial for back-translation](https://github.com/pytorch/fairseq/tree/master/examples/backtranslation#training-your-own-model-wmt18-english-german)
- December 2019: [fairseq 0.9.0 released](https://github.com/pytorch/fairseq/releases/tag/v0.9.0)
- November 2019: [VizSeq released (a visual analysis toolkit for evaluating fairseq models)](https://facebookresearch.github.io/vizseq/docs/getting_started/fairseq_example)
- November 2019: [CamemBERT model and code released](examples/camembert/README.md)
- November 2019: [BART model and code released](examples/bart/README.md)
- November 2019: [XLM-R models and code released](examples/xlmr/README.md)
- September 2019: [Nonautoregressive translation code released](examples/nonautoregressive_translation/README.md)
- August 2019: [WMT'19 models released](examples/wmt19/README.md)
- July 2019: fairseq relicensed under MIT license
- July 2019: [RoBERTa models and code released](examples/roberta/README.md)
- June 2019: [wav2vec models and code released](examples/wav2vec/README.md)

### Features:

Fairseq provides reference implementations of various sequence-to-sequence models, including:
- **Convolutional Neural Networks (CNN)**
  - [Language Modeling with Gated Convolutional Networks (Dauphin et al., 2017)](examples/language_model/conv_lm/README.md)
  - [Convolutional Sequence to Sequence Learning (Gehring et al., 2017)](examples/conv_seq2seq/README.md)
  - [Classical Structured Prediction Losses for Sequence to Sequence Learning (Edunov et al., 2018)](https://github.com/pytorch/fairseq/tree/classic_seqlevel)
  - [Hierarchical Neural Story Generation (Fan et al., 2018)](examples/stories/README.md)
  - [wav2vec: Unsupervised Pre-training for Speech Recognition (Schneider et al., 2019)](examples/wav2vec/README.md)
- **LightConv and DynamicConv models**
  - [Pay Less Attention with Lightweight and Dynamic Convolutions (Wu et al., 2019)](examples/pay_less_attention_paper/README.md)
- **Long Short-Term Memory (LSTM) networks**
  - Effective Approaches to Attention-based Neural Machine Translation (Luong et al., 2015)
- **Transformer (self-attention) networks**
  - Attention Is All You Need (Vaswani et al., 2017)
  - [Scaling Neural Machine Translation (Ott et al., 2018)](examples/scaling_nmt/README.md)
  - [Understanding Back-Translation at Scale (Edunov et al., 2018)](examples/backtranslation/README.md)
  - [Adaptive Input Representations for Neural Language Modeling (Baevski and Auli, 2018)](examples/language_model/transformer_lm/README.md)
  - [Mixture Models for Diverse Machine Translation: Tricks of the Trade (Shen et al., 2019)](examples/translation_moe/README.md)
  - [RoBERTa: A Robustly Optimized BERT Pretraining Approach (Liu et al., 2019)](examples/roberta/README.md)
  - [Facebook FAIR's WMT19 News Translation Task Submission (Ng et al., 2019)](examples/wmt19/README.md)
  - [Jointly Learning to Align and Translate with Transformer Models (Garg et al., 2019)](examples/joint_alignment_translation/README.md )
  - [Multilingual Denoising Pre-training for Neural Machine Translation (Liu et at., 2020)](examples/mbart/README.md)
  - [Neural Machine Translation with Byte-Level Subwords (Wang et al., 2020)](examples/byte_level_bpe/README.md)
- **Non-autoregressive Transformers**
  - Non-Autoregressive Neural Machine Translation (Gu et al., 2017)
  - Deterministic Non-Autoregressive Neural Sequence Modeling by Iterative Refinement (Lee et al. 2018)
  - Insertion Transformer: Flexible Sequence Generation via Insertion Operations (Stern et al. 2019)
  - Mask-Predict: Parallel Decoding of Conditional Masked Language Models (Ghazvininejad et al., 2019)
  - [Levenshtein Transformer (Gu et al., 2019)](examples/nonautoregressive_translation/README.md)


**Additionally:**
- multi-GPU (distributed) training on one machine or across multiple machines
- fast generation on both CPU and GPU with multiple search algorithms implemented:
  - beam search
  - Diverse Beam Search ([Vijayakumar et al., 2016](https://arxiv.org/abs/1610.02424))
  - sampling (unconstrained, top-k and top-p/nucleus)
- large mini-batch training even on a single GPU via delayed updates
- mixed precision training (trains faster with less GPU memory on [NVIDIA tensor cores](https://developer.nvidia.com/tensor-cores))
- extensible: easily register new models, criterions, tasks, optimizers and learning rate schedulers

We also provide [pre-trained models for translation and language modeling](#pre-trained-models-and-examples)
with a convenient `torch.hub` interface:
```python
en2de = torch.hub.load('pytorch/fairseq', 'transformer.wmt19.en-de.single_model')
en2de.translate('Hello world', beam=5)
# 'Hallo Welt'
```
See the PyTorch Hub tutorials for [translation](https://pytorch.org/hub/pytorch_fairseq_translation/)
and [RoBERTa](https://pytorch.org/hub/pytorch_fairseq_roberta/) for more examples.

![Model](fairseq.gif)

# Requirements and Installation

* [PyTorch](http://pytorch.org/) version >= 1.4.0
* Python version >= 3.6
* For training new models, you'll also need an NVIDIA GPU and [NCCL](https://github.com/NVIDIA/nccl)
* **For faster training** install NVIDIA's [apex](https://github.com/NVIDIA/apex) library with the `--cuda_ext` and `--deprecated_fused_adam` options

To install fairseq:
```bash
pip install fairseq
```

On MacOS:
```bash
CFLAGS="-stdlib=libc++" pip install fairseq
```

If you use Docker make sure to increase the shared memory size either with
`--ipc=host` or `--shm-size` as command line options to `nvidia-docker run`.

**Installing from source**

To install fairseq from source and develop locally:
```bash
git clone https://github.com/pytorch/fairseq
cd fairseq
pip install --editable .
```

# Getting Started

The [full documentation](https://fairseq.readthedocs.io/) contains instructions
for getting started, training new models and extending fairseq with new model
types and tasks.

# Pre-trained models and examples

We provide pre-trained models and pre-processed, binarized test sets for several tasks listed below,
as well as example training and evaluation commands.

- [Translation](examples/translation/README.md): convolutional and transformer models are available
- [Language Modeling](examples/language_model/README.md): convolutional and transformer models are available
- [wav2vec](examples/wav2vec/README.md): wav2vec large model is available

We also have more detailed READMEs to reproduce results from specific papers:
- [Neural Machine Translation with Byte-Level Subwords (Wang et al., 2020)](examples/byte_level_bpe/README.md)
- [Jointly Learning to Align and Translate with Transformer Models (Garg et al., 2019)](examples/joint_alignment_translation/README.md )
- [Levenshtein Transformer (Gu et al., 2019)](examples/nonautoregressive_translation/README.md)
- [Facebook FAIR's WMT19 News Translation Task Submission (Ng et al., 2019)](examples/wmt19/README.md)
- [RoBERTa: A Robustly Optimized BERT Pretraining Approach (Liu et al., 2019)](examples/roberta/README.md)
- [wav2vec: Unsupervised Pre-training for Speech Recognition (Schneider et al., 2019)](examples/wav2vec/README.md)
- [Mixture Models for Diverse Machine Translation: Tricks of the Trade (Shen et al., 2019)](examples/translation_moe/README.md)
- [Pay Less Attention with Lightweight and Dynamic Convolutions (Wu et al., 2019)](examples/pay_less_attention_paper/README.md)
- [Understanding Back-Translation at Scale (Edunov et al., 2018)](examples/backtranslation/README.md)
- [Classical Structured Prediction Losses for Sequence to Sequence Learning (Edunov et al., 2018)](https://github.com/pytorch/fairseq/tree/classic_seqlevel)
- [Hierarchical Neural Story Generation (Fan et al., 2018)](examples/stories/README.md)
- [Scaling Neural Machine Translation (Ott et al., 2018)](examples/scaling_nmt/README.md)
- [Convolutional Sequence to Sequence Learning (Gehring et al., 2017)](examples/conv_seq2seq/README.md)
- [Language Modeling with Gated Convolutional Networks (Dauphin et al., 2017)](examples/language_model/conv_lm/README.md)

# Join the fairseq community

* Facebook page: https://www.facebook.com/groups/fairseq.users
* Google group: https://groups.google.com/forum/#!forum/fairseq-users

# License
fairseq(-py) is MIT-licensed.
The license applies to the pre-trained models as well.

# Citation

Please cite as:

```bibtex
@inproceedings{ott2019fairseq,
  title = {fairseq: A Fast, Extensible Toolkit for Sequence Modeling},
  author = {Myle Ott and Sergey Edunov and Alexei Baevski and Angela Fan and Sam Gross and Nathan Ng and David Grangier and Michael Auli},
  booktitle = {Proceedings of NAACL-HLT 2019: Demonstrations},
  year = {2019},
}
```
