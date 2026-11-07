<p align="center">
  <img src="leshu/leshu.png" alt="Leshu" width="160">
</p>

# Lichii Leshu

[English](README.md) · **Español**

**Leshu** es una versión optimizada de [Lichii Frizti](https://github.com/Frizti/Lichii), el fork del emulador de Switch 2 ajustado para *The Legend of Zelda: Ocarina of Time*. No cambia lo que el emulador emula: es el mismo código que Frizti v3, compilado de otra forma.

- **clang-cl + ThinLTO + PGO** (optimización guiada por perfil, entrenada con Ocarina of Time). El perfil de Leshu 2 está grabado como se juega: Dock 1080p, con Link caminando y girando la cámara, en seis situaciones.
- **Versión general x86-64-v3**: funciona en cualquier procesador con AVX2 (Intel de 4.ª generación/Haswell o posterior, cualquier AMD Ryzen).
- **Lista para jugar**: los ajustes de Frizti v3 para Ocarina of Time vienen de serie. Pon tus claves y tu firmware y abre el juego.

> Todo el mérito del emulador es de sus autores (ver **Créditos**). Leshu solo lo compila, lo mide y lo ajusta.

## Resultados

Modo Dock, 1080p, i7-11700F + RTX 3060, FPS medio durante 96 s después de cargar la partida.

**Leshu 2 contra Leshu 1** (`eden-cli`, dos pruebas de cada; "caminando" = Link camina en cuadrado y gira la cámara):

| Zona | Leshu 1 | **Leshu 2** |
|---|---|---|
| Aldea Kokiri, quieto | 33,6 | **34,2** |
| Aldea Kokiri, caminando | 39,9 | **42,9 (+7%)** |
| Campo de Hyrule, quieto | 40,1 | 39,9 |
| Campo de Hyrule, caminando | 37,1 | **41,3 (+11%)** |

**Leshu 1 contra la versión oficial de Frizti v3** (`lichii.exe`, Link quieto):

| Zona | Frizti v3 (versión oficial) | Leshu 1 |
|---|---|---|
| Aldea Kokiri | 34,1 | **35,3 (+3,5%)** |
| Campo de Hyrule | 43,3 | **43,9 (+1%)** |

Las versiones oficiales de Frizti v3 ya usan clang + PGO (con su propio perfil), así que compilar mejor gana poco con Link quieto; los perfiles de Leshu están entrenados solo con Ocarina of Time, y el de Leshu 2 jugando. Caminando, los FPS varían mucho según hacia dónde mire la cámara (18-58 FPS dentro de una misma prueba en Hyrule): toma esas medias como aproximadas.

## Instalación (Windows)

1. Instala el [Microsoft Visual C++ Redistributable (x64)](https://aka.ms/vs/17/release/vc_redist.x64.exe) si no lo tienes.
2. Descarga `Leshu-2-Windows-x64.zip` de [Releases](https://github.com/leshupro/Leshu/releases) y extrae la carpeta completa.
3. Pon tus propios `prod.keys` y `title.keys` en `user/keys/` e instala el firmware sacado de tu propia consola (Herramientas → Instalar firmware).
4. Abre **lichii.exe**, añade la carpeta de tus juegos y a jugar.

La carpeta `user` junto a `lichii.exe` hace que sea portátil: las partidas, los ajustes y la caché de shaders se quedan dentro. Para aprovechar una instalación anterior de Lichii/Eden, copia allí tu carpeta `user` antigua (haz antes una copia de seguridad de tus partidas).

Leshu **no incluye claves, firmware ni juegos**. Sácalos de tu propia consola.

### Ajustes

No hace falta tocar nada. El archivo `nx2_switches.txt` junto al ejecutable explica los interruptores de GPU para quien quiera experimentar. Los ajustes de serie de Frizti v3 (Dock, 8 GB de memoria, precisión de GPU baja, shaders y presentación asíncronos, la opción de 60/30 FPS para Ocarina) se aplican solos.

## Lo que se midió y no ayudó

Dentro de ±1 FPS en este PC: GPU Fence "Immediate", precisión de CPU "Unsafe", reemplazo por DLSS, desactivar el post-procesado, VSync desactivado, 8 contra 12 GB de memoria, la mayoría de experimentos `EDEN_NX2_PERF_ON`, quitar las barreras cómputo→gráficos y de espera que añadió Frizti v3 (#295), el modo de VSync y el filtro de escalado (Hyrule en Dock). `EDEN_NX2_INDIRECT_GRID=1` (dispatches dimensionados por la GPU) daba +10% quieto en la aldea, pero caminando iba más lento y con destellos, así que sigue apagado como lo dejó Frizti.

El modo portátil (720p) va ~5 FPS más rápido que el Dock (1080p) en el campo de Hyrule, donde la GPU trabaja al ~80%. En zonas pequeñas el límite es la CPU y los dos modos rinden igual.

## Compilar Leshu

Requisitos: Visual Studio 2022/2026 con "Desarrollo para el escritorio con C++", los componentes de herramientas Clang de C++ y de CMake, y el Vulkan SDK.

```bat
:: Compilación optimizada con el perfil (descarga leshu2-pgo-profile.zip de Releases en pgo\l2.profdata)
leshu\scripts\configure_leshu.bat use l2.profdata
leshu\scripts\build_dir.bat build-leshu
```

Para grabar tu propio perfil: `configure_leshu.bat gen`, compila `build-leshugen`, ejecuta el `eden-cli` instrumentado en varias zonas (`leshu/bench/pgotrain_v3.sh` lo cierra de forma normal para que se escriban los `.profraw`) y luego `llvm-profdata merge -o pgo\v3.profdata <archivos>.profraw`.

Ninja no recompila cuando solo cambia el `.profdata`: borra antes los `.obj`. Los scripts tienen rutas absolutas (`D:\lichii\...`); ajústalas a las tuyas.

## Prueba automática (`leshu/bench/`)

Arranca el juego, carga la última partida con un guion de teclas y anota los FPS sin que nadie juegue, para comparar cada cambio de forma justa. Pon en `ROM` la ruta de tu propio volcado.

- `bench.sh` / `run1.sh` / `batch.sh`: ejecuciones de `eden-cli` con un archivo de interruptores y cambios de configuración (`setcfg.py`).
- `qtbench.py` / `qtpair.sh`: lo mismo para `lichii.exe`, a través de su servidor de depuración.
- `gpurun.sh`: además registra el uso de la GPU con `nvidia-smi`.

Lecciones: compara versiones solo con los mismos ajustes gráficos (solo el cambio Dock/portátil movió Hyrule 5 FPS), espera a tener ~22 GB de memoria comprometida libre antes de cada prueba y lee las líneas de FPS de forma estricta.

`leshu/patches-v2-experiments/` guarda experimentos sobre Frizti v2 (semáforos y predicción de señales QMD). Eran correctos pero no subieron los FPS y no están en Leshu 1.

## Créditos

- **Lichii Frizti**, de Frizti: la base de Leshu, con el trabajo para Ocarina of Time.
- **Lichii**, de zortos293 y colaboradores.
- **Eglantine**, **Eden** y **Sudachi**, y antes el proyecto **yuzu**.
- **Dynamic FPS by Dark** (incluido en Lichii Frizti), **EvilOOT** y todos aquellos cuyos arreglos incorporó Frizti.
- Compilación y mediciones de Leshu: leshupro, con Claude (Anthropic).

El README original de Lichii está en [README.lichii.md](README.lichii.md).

## Licencia

GPL-3.0 o posterior, como Lichii. Ni Lichii ni Leshu tienen relación con Nintendo.
