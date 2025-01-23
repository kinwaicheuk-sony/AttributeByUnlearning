wait_time=300  # Time is in seconds (300 seconds = 5 minutes)
echo "Waiting for $((wait_time / 60)) minutes before starting the jobs..."
sleep $wait_time

for idx in 50 100 200 300 400 500; do
    CUDA_VISIBLE_DEVICES=$GPU python compute_influence.py \
        --result_dir results_ablation \
        --sample_latent_path data/mscoco/coco17_sample_latents.npy \
        --sample_text_path data/mscoco/coco17_sample_text_embeddings.npy \
        --sample_idx 0 \
        --unlearn_grad_accum_steps $idx \
        --pretrain_loss_path results/pretrain_loss.npy &

    # Increment GPU index for the next job
    ((GPU++))        
done

# Wait for all background processes to finish
wait
echo "All jobs completed!"