# Use NVIDIA CUDA 12.6 base image with Ubuntu 24.04
FROM nvidia/cuda:12.6.3-cudnn-runtime-ubuntu24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3.11-venv \
    python3-pip \
    git \
    wget \
    curl \
    ffmpeg \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    libglib2.0-0 \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6 \
    libgomp1 \
    gcc \
    g++ \
    make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create Python virtual environment
RUN python3.11 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip
RUN pip install --upgrade pip wheel setuptools

# Clone ComfyUI v0.3.42
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /app/ComfyUI && \
    cd /app/ComfyUI && \
    git checkout v0.3.42

# Set ComfyUI as working directory
WORKDIR /app/ComfyUI

# Install PyTorch with CUDA 12.6 support
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126

# Install ComfyUI requirements
RUN pip install -r requirements.txt

# Install additional dependencies for better compatibility
RUN pip install \
    opencv-python \
    transformers \
    accelerate \
    safetensors \
    scipy \
    kornia \
    spandrel \
    soundfile

# Clone and install ComfyUI-Manager
RUN cd custom_nodes && \
    git clone https://github.com/Comfy-Org/ComfyUI-Manager.git && \
    cd ComfyUI-Manager && \
    pip install -r requirements.txt

# Create necessary directories
RUN mkdir -p \
    /app/ComfyUI/models/checkpoints \
    /app/ComfyUI/models/vae \
    /app/ComfyUI/models/loras \
    /app/ComfyUI/models/embeddings \
    /app/ComfyUI/models/controlnet \
    /app/ComfyUI/models/clip \
    /app/ComfyUI/models/unet \
    /app/ComfyUI/models/upscale_models \
    /app/ComfyUI/input \
    /app/ComfyUI/output \
    /app/ComfyUI/temp

# Set permissions
RUN chmod -R 777 /app/ComfyUI

# Expose port for ComfyUI web interface
EXPOSE 8188

# Set the entrypoint
ENTRYPOINT ["python", "main.py"]

# Default command with arguments for better previews and listening on all interfaces
CMD ["--listen", "0.0.0.0", "--port", "8188", "--preview-method", "auto"]
