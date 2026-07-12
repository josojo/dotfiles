ARCH="$(uname -m)"

case "$ARCH" in
  x86_64)
    NVIM_ARCH="x86_64"
    ;;
  aarch64|arm64)
    NVIM_ARCH="arm64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz"

sudo rm -rf /opt/nvim
sudo mkdir -p /opt/nvim
sudo tar -C /opt/nvim --strip-components=1 \
  -xzf "nvim-linux-${NVIM_ARCH}.tar.gz"

sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim

nvim --version
