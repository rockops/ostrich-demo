echo "=== Cloning ostrich-sdk ==="

cd /rockdemo

TOKEN=$(test -f "$HOME/secret/github.txt" && tr -d '\n' < "$HOME/secret/github.txt")

if [ -d /rockdemo/ostrich-sdk ]; then
    git pull
else
    git clone "https://${TOKEN}@github.com/rockops/ostrich-sdk.git" "/rockdemo/ostrich-sdk"
fi

mkdir -p /rockdemo/venv
if [ ! -d /rockdemo/venv/bin ]; then
    python3 -m venv /rockdemo/venv
fi

cd "/rockdemo/ostrich-sdk/ost-core"
/rockdemo/venv/bin/pip install --upgrade pip
/rockdemo/venv/bin/pip install -r requirements.txt
