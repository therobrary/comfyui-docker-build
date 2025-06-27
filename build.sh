#!/bin/bash

# Build script for ComfyUI Docker image

echo "Building ComfyUI Docker image with NVIDIA CUDA 12.4 support..."

# Create necessary directories
mkdir -p models/checkpoints models/vae models/loras models/embeddings models/controlnet models/clip models/unet models/upscale_models
mkdir -p input output custom_nodes

# Build the Docker image
docker-compose build --no-cache

echo "Build complete!"
echo ""
echo "To start ComfyUI, run:"
echo "  docker-compose up -d"
echo ""
echo "Then access ComfyUI at: http://localhost:8188"
echo ""
echo "To view logs:"
echo "  docker-compose logs -f comfyui"
