#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)"
DATA_DIR="${HOME}/.wisdom-bytes"
ZSHRC="${HOME}/.zshrc"
SOURCE_LINE="source \"${INSTALL_DIR}/wisdom.sh\""

echo "Installing Wisdom Bytes..."

mkdir -p "$DATA_DIR"

if [[ ! -f "${DATA_DIR}/history" ]]; then
  touch "${DATA_DIR}/history"
  echo "  Created ${DATA_DIR}/history"
fi

if grep -Fxq "$SOURCE_LINE" "$ZSHRC" 2>/dev/null; then
  echo "  Sourcing line already in ${ZSHRC} — skipping."
else
  echo "" >> "$ZSHRC"
  echo "# Wisdom Bytes — random wisdom on terminal start" >> "$ZSHRC"
  echo "$SOURCE_LINE" >> "$ZSHRC"
  echo "  Added sourcing line to ${ZSHRC}"
fi

echo ""
echo " Wisdom Bytes installed!"
echo ""
echo "  Concepts:  ${INSTALL_DIR}/concepts/"
echo "  Data:      ${DATA_DIR}/"
echo ""
echo " Open a new terminal to see your first wisdom byte."
echo " Or run: source ${INSTALL_DIR}/wisdom.sh"
