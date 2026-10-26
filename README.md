# PriShot · descargas

Instaladores de **PriShot**, una herramienta de capturas de pantalla al estilo Lightshot: seleccionas
una región, la anotas (flechas, rectángulos, texto, pixelado) y la copias o la guardas.
Aquí solo están los instaladores; el código vive en un repositorio privado.

## Instalar

**Mac** (Apple Silicon, macOS 13 o superior). Abre la app **Terminal** y pega:

```bash
curl -fsSL https://raw.githubusercontent.com/jose-albarracin/prishot-descargas/main/instalar.sh | bash
```

**Windows** (64 bits). Abre **PowerShell** y pega:

```powershell
irm https://raw.githubusercontent.com/jose-albarracin/prishot-descargas/main/instalar.ps1 | iex
```

El comando baja la última versión, comprueba su sha256, la instala y abre PriShot.
Para actualizar, se vuelve a pegar el mismo comando.

> Si en vez del comando bajas el `.dmg` o el `.exe` con el navegador desde
> [Releases](https://github.com/jose-albarracin/prishot-descargas/releases), el sistema muestra un
> aviso porque la app no tiene firma de un desarrollador registrado: en Mac hay que ir a
> *Ajustes del Sistema → Privacidad y seguridad → Abrir igualmente*, y en Windows a
> *Más información → Ejecutar de todas formas*. Con el comando no aparece ese aviso.

## Atajos

| Acción | Windows | Mac |
|---|---|---|
| Capturar región (abre el editor) | `ImpPt` | `⇧⌘9` |
| Guardar pantalla completa | `Mayús+ImpPt` | `⇧⌘8` |
| Copiar pantalla completa | `Ctrl+ImpPt` | `⇧⌘7` |

En Mac, la primera captura pide el permiso de **Grabación de pantalla**
(*Ajustes del Sistema → Privacidad y seguridad → Grabación de pantalla → PriShot*).

## Desinstalar

- **Mac:** sal de PriShot desde su icono en la barra de menú y borra `PriShot.app` de Aplicaciones.
- **Windows:** *Configuración → Aplicaciones → Aplicaciones instaladas → PriShot → Desinstalar*.

## Archivos de cada versión

| Archivo | Para |
|---|---|
| `PriShot-mac-arm64.dmg` | Mac con Apple Silicon |
| `PriShot-Setup-x64.exe` | Windows de 64 bits |
| `SHA256SUMS.txt` | Comprobar las descargas |

© 2026 Jose Daniel Albarracin · Licencia MIT.
