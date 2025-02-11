CUDA_VISIBLE_DEVICES=0 python compute_influence.py \
    --result_dir my_results_ablation \
    --sample_latent_path /tss/kinwai/AttributeByUnlearning/mscoco/my_samples/test_sample/latents.npy \
    --sample_text_path /tss/kinwai/AttributeByUnlearning/mscoco/my_samples/test_sample/text_embeddings.npy \
    --sample_idx 4 \
    --pretrain_loss_path results/pretrain_loss.npy
