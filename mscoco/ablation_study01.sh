
for idx in {1..3}; do
    CUDA_VISIBLE_DEVICES=$GPU python compute_influence.py \
        --result_dir results_ablation \
        --sample_latent_path data/mscoco/coco17_sample_latents.npy \
        --sample_text_path data/mscoco/coco17_sample_text_embeddings.npy \
        --sample_idx $idx \
        --pretrain_loss_path results/pretrain_loss.npy
done
