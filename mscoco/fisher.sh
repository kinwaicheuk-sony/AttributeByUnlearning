CUDA_VISIBLE_DEVICES=5 python compute_influence.py \
    --result_dir fisher_reproduce \
    --fisher_path /tss/kinwai/AttributeByUnlearning/mscoco/fisher_by_epochs/fisher_4.pt \
    --sample_latent_path data/mscoco/coco17_sample_latents.npy \
    --sample_text_path data/mscoco/coco17_sample_text_embeddings.npy \
    --sample_idx 0 \
     --pretrain_loss_path results/pretrain_loss.npy