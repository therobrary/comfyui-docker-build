# ComfyUI build to support The Robrary

## ComfyUI Docker Deployment with NVIDIA Support

This Docker setup provides ComfyUI v0.3.42 with NVIDIA CUDA 12.4 support, including ComfyUI Manager and Better Previews functionality.

## Features

- **ComfyUI v0.3.42**: The latest stable version
- **NVIDIA CUDA 12.4**: Full GPU acceleration support
- **ComfyUI Manager**: Pre-installed for easy node management
- **Better Previews**: Enabled with auto preview method
- **Persistent Storage**: Models, inputs, and outputs are stored on the host

## Prerequisites

- Docker and Docker Compose installed
- NVIDIA Docker runtime (nvidia-docker2)
- NVIDIA GPU with CUDA 12.4 compatible drivers

## Installation

### Install NVIDIA Docker Runtime (if not already installed)

```bash
# Add the NVIDIA repository
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

# Install nvidia-docker2
sudo apt-get update
sudo apt-get install -y nvidia-docker2

# Restart Docker
sudo systemctl restart docker
```

## Quick Start

1. Clone this repository:
```bash
git clone <your-repo-url>
cd comfyui-docker
```

2. Build the Docker image:
```bash
docker-compose build
```

3. Start ComfyUI:
```bash
docker-compose up -d
```

4. Access ComfyUI at: http://localhost:8188

## Directory Structure

```
.
├── Dockerfile
├── docker-compose.yml
├── README.md
├── models/           # Your AI models (persistent)
├── input/            # Input images (persistent)
├── output/           # Generated images (persistent)
└── custom_nodes/     # Custom nodes directory (persistent)
```

## Managing Models

Place your models in the appropriate subdirectories:
- Checkpoints: `./models/checkpoints/`
- VAE: `./models/vae/`
- LoRA: `./models/loras/`
- Embeddings: `./models/embeddings/`
- ControlNet: `./models/controlnet/`

## Using ComfyUI Manager

ComfyUI Manager is pre-installed and accessible from the web interface. You can:
- Install custom nodes
- Update ComfyUI
- Manage models
- Install missing dependencies

## Custom Configuration

To modify ComfyUI startup parameters, edit the `command` section in `docker-compose.yml`:

```yaml
command: ["--listen", "0.0.0.0", "--port", "8188", "--preview-method", "auto", "--gpu-only"]
```

Available options:
- `--preview-method`: auto, latent2rgb, taesd (auto recommended for better previews)
- `--gpu-only`: Force GPU-only mode
- `--highvram`: Enable high VRAM mode
- `--normalvram`: Use normal VRAM mode
- `--lowvram`: Enable low VRAM mode
- `--cpu`: Use CPU only (not recommended)

## Troubleshooting

### GPU not detected
```bash
# Check if NVIDIA runtime is available
docker run --rm --gpus all nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi
```

### Permission issues
```bash
# Fix permissions for mounted directories
sudo chown -R $USER:$USER ./models ./input ./output ./custom_nodes
```

### View logs
```bash
docker-compose logs -f comfyui
```

## Updating

To update to a newer version of ComfyUI:
1. Modify the git checkout command in the Dockerfile
2. Rebuild the image: `docker-compose build --no-cache`
3. Restart the container: `docker-compose up -d`

## Security Notes

- The container runs with broad permissions for ease of use
- For production deployments, consider restricting permissions
- The web interface is exposed on all interfaces (0.0.0.0)
