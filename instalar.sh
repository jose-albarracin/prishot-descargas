#!/bin/bash
# Instalador de PriShot para macOS (Apple Silicon).
# Uso:  curl -fsSL https://raw.githubusercontent.com/jose-albarracin/prishot-descargas/main/instalar.sh | bash
#
# Descarga el .dmg de la última versión publicada, comprueba su sha256, copia
# PriShot.app en /Applications (o ~/Applications si no hay permiso) y la abre.
set -euo pipefail

REPO="jose-albarracin/prishot-descargas"
BASE="https://github.com/$REPO/releases/latest/download"
DMG_NAME="PriShot-mac-arm64.dmg"

say()  { printf '\033[1m==>\033[0m %s\n' "$*"; }
fail() { printf '\033[31mError:\033[0m %s\n' "$*" >&2; exit 1; }

[ "$(uname -s)" = "Darwin" ] || fail "este instalador es para macOS. En Windows usa instalar.ps1."
[ "$(uname -m)" = "arm64" ]  || fail "PriShot para Mac solo existe para Apple Silicon (M1 o posterior)."
major=$(sw_vers -productVersion | cut -d. -f1)
[ "$major" -ge 13 ] || fail "PriShot necesita macOS 13 o superior (tienes $(sw_vers -productVersion))."

TMP=$(mktemp -d)
MNT="$TMP/mnt"
cleanup() { hdiutil detach "$MNT" -quiet 2>/dev/null || true; rm -rf "$TMP"; }
trap cleanup EXIT

say "Descargando PriShot..."
curl -fL --progress-bar -o "$TMP/$DMG_NAME" "$BASE/$DMG_NAME"
curl -fsSL -o "$TMP/SHA256SUMS.txt" "$BASE/SHA256SUMS.txt"

say "Comprobando el archivo..."
expected=$(grep " $DMG_NAME\$" "$TMP/SHA256SUMS.txt" | awk '{print $1}')
actual=$(shasum -a 256 "$TMP/$DMG_NAME" | awk '{print $1}')
[ -n "$expected" ] && [ "$expected" = "$actual" ] || fail "el sha256 no coincide; descarga dañada. Vuelve a intentarlo."

say "Instalando..."
mkdir -p "$MNT"
hdiutil attach "$TMP/$DMG_NAME" -nobrowse -readonly -quiet -mountpoint "$MNT"
[ -d "$MNT/PriShot.app" ] || fail "el .dmg no trae PriShot.app."

DEST="/Applications"
[ -w "$DEST" ] || { DEST="$HOME/Applications"; mkdir -p "$DEST"; }

# Cerrar la versión abierta antes de reemplazarla.
pkill -x PriShot 2>/dev/null && sleep 1 || true
rm -rf "$DEST/PriShot.app"
ditto "$MNT/PriShot.app" "$DEST/PriShot.app"
# Por si acaso: si algo marcó la app como descargada de internet, se quita la marca.
xattr -dr com.apple.quarantine "$DEST/PriShot.app" 2>/dev/null || true

say "PriShot quedó en $DEST/PriShot.app"
open "$DEST/PriShot.app"
cat <<'EOF'

Listo. PriShot vive en la barra de menú (arriba a la derecha).
  ⇧⌘9  capturar una región
  ⇧⌘8  guardar la pantalla
  ⇧⌘7  copiar la pantalla
La primera captura pide el permiso de Grabación de pantalla:
Ajustes del Sistema → Privacidad y seguridad → Grabación de pantalla → PriShot.
Para actualizar, vuelve a pegar el mismo comando.
EOF
