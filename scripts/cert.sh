#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CERT_DIR="$SCRIPT_DIR/../server/certs"
CERT_FILE="$CERT_DIR/server.cert"
KEY_FILE="$CERT_DIR/server.key"

mkdir -p "$CERT_DIR"

if [[ -f "$CERT_FILE" && -f "$KEY_FILE" ]]; then
	echo "SSL certificates already exist:"
	echo "  $CERT_FILE"
	echo "  $KEY_FILE"
	exit 0
fi

openssl req -x509 -nodes -newkey rsa:2048 -sha256 -days 365 \
	-keyout "$KEY_FILE" \
	-out "$CERT_FILE" \
	-subj "/C=BR/ST=State/L=City/O=MusicRooms/OU=Development/CN=localhost" \
	-addext "subjectAltName=DNS:localhost,IP:127.0.0.1,IP:::1"

chmod 600 "$KEY_FILE"

echo "SSL certificates generated:"
echo "  $CERT_FILE"
echo "  $KEY_FILE"

