echo "=== Cloning ostrich-sdk ==="

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

#TOKEN=$(test -f "/root/secret/github.txt" && cat /root/secret/github.txt && echo "@")

# if [ -d /rockdemo/ostrich-sdk ]; then
#     cd /rockdemo/ostrich-sdk
#     git pull
#     cd /rockdemo
# else
#     git clone -b feat/pip-install "https://${TOKEN}github.com/rockops/ostrich-sdk.git" "/rockdemo/ostrich-sdk"
# fi

mkdir -p /rockdemo/venv
if [ ! -d /rockdemo/venv/bin ]; then
    python3 -m venv /rockdemo/venv
fi

#cd "/rockdemo/ostrich-sdk/ost-core"
#/rockdemo/venv/bin/pip install --upgrade pip
#/rockdemo/venv/bin/pip install -r requirements.txt

# cd /rockdemo/ostrich-sdk
# /rockdemo/venv/bin/pip install ./ost-core

USER="USERNAME"
TOKEN=$(test -f "/root/secret/github_read_osplates.txt" && cat /root/secret/github_read_osplates.txt)
if [ -n "$TOKEN" ]; then
    HELM_CONFIG_HOME="/root/.ostrich/helm/config" helm registry login ghcr.io -u "$USER" -p "$TOKEN"
fi

