#!/bin/sh

# exists if something fails
set -e

COMMAND="/usr/sbin/sshd -D"
echo "Preparing container ..."

CMD_GEN="ssh-keygen"

HOST_SSH_PATH="/etc/ssh"

HOST_DSA_KEY_FILE="${HOST_SSH_PATH}/ssh_host_dsa_key"
HOST_RSA_KEY_FILE="${HOST_SSH_PATH}/ssh_host_rsa_key"
HOST_ECDSA_KEY_FILE="${HOST_SSH_PATH}/ssh_host_ecdsa_key"
HOST_ED25519_KEY_FILE="${HOST_SSH_PATH}/ssh_host_ed25519_key"

echo "Checking for keys ..."

if [ ! -f "$HOST_DSA_KEY_FILE" ]; then
  echo "Host DSA key file does not exists. Generating..."
  $CMD_GEN -N '' -t dsa -f $HOST_DSA_KEY_FILE
fi

if [ ! -f "$HOST_RSA_KEY_FILE" ]; then
  echo "Host RSA key file does not exists. Generating..."
  $CMD_GEN -N '' -t rsa -f $HOST_RSA_KEY_FILE
fi

if [ ! -f "$HOST_ECDSA_KEY_FILE" ]; then
  echo "Host ECDSA key file does not exists. Generating..."
  $CMD_GEN -N '' -t ecdsa -f $HOST_ECDSA_KEY_FILE
fi

if [ ! -f "$HOST_ED25519_KEY_FILE" ]; then
  echo "Host ED25519 key file does not exists. Generating..."
  $CMD_GEN -N '' -t ed25519 -f $HOST_ED25519_KEY_FILE
fi

echo "Looking for authorized_keys file into /tmp/authorized_keys"
if [ -f "/tmp/authorized_keys"]; then
  echo "Found authorized_keys file. Replacing root's..."
  cat /tmp/authorized_keys > /root/.ssh/authorized_keys
  chmod 600 /root/.ssh/authorized_keys
fi

echo "All systems go! Starting command..."

if [ "$@" = "${COMMAND}" ]; then
  echo "Executing ${COMMAND}"
  exec ${COMMAND}
else
  echo "Not executing ${COMMAND}"
  echo "Executing ${@}"
  exec $@
fi
