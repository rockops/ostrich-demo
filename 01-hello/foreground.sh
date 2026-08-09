while [ ! -f /tmp/finished ]; do sleep 1; echo -n "."; done
echo "Environment ready!"