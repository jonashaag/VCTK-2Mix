#!/bin/bash
set -e  # Exit on error

storage_dir=$1

echo "Download wham_noise into $storage_dir"
# If downloading stalls for more than 20s, relaunch from previous state.
wget -c --tries=0 --read-timeout=20 https://storage.googleapis.com/whisper-public/wham_noise.zip -P $storage_dir
unzip -qn $storage_dir/wham_noise.zip -d $storage_dir
rm -rf $storage_dir/wham_noise.zip


echo "Download VCTK into $storage_dir"
# If downloading stalls for more than 20s, relaunch from previous state.
wget -c --tries=0 --read-timeout=20 https://datashare.is.ed.ac.uk/bitstream/handle/10283/2651/VCTK-Corpus.zip?sequence=2&isAllowed=y -P $storage_dir
unzip -qn $storage_dir/VCTK-Corpus.zip -d $storage_dir
rm -rf $storage_dir/VCTK-Corpus.zip


VCTK_dir=$storage_dir/VCTK-Corpus/
wham_dir=$storage_dir/wham_noise
VCTKmix_outdir=$storage_dir/
metadata_dir=metadata/VCTK-2mix/

python scripts/preprocesing.py --VCTK_dir $VCTK_dir
python scripts/create_VCTKmix_from_metadata.py \
      --VCTK_dir $VCTK_dir \
      --wham_dir $wham_dir \
      --metadata_dir $metadata_dir \
      --VCTKmix_outdir $VCTKmix_outdir \
      --n_src 2 \
      --freqs 8k 16k \
      --modes min max \
      --types mix_clean mix_both mix_single
