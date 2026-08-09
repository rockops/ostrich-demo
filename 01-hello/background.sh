echo "=== Cloning ostrich-sdk ==="

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

apt-get install -y -qq python3-venv

mkdir -p /rockdemo/venv
if [ ! -d /rockdemo/venv/bin ]; then
    python3 -m venv /rockdemo/venv
fi

GLOW_VERSION=2.1.2

cd /rockdemo

if [ ! -f helm ]; then
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
    chmod 700 get_helm.sh
    ./get_helm.sh
    cp /usr/local/bin/helm .
    rm get_helm.sh
else
    cp helm /usr/local/bin
fi

if [ ! -f glow_${GLOW_VERSION}_amd64.deb ]; then
    wget https://github.com/charmbracelet/glow/releases/download/v$GLOW_VERSION/glow_${GLOW_VERSION}_amd64.deb
fi

dpkg -i glow_${GLOW_VERSION}_amd64.deb

touch /tmp/finished
