<p align="center">
  <img src="leshu/leshu.png" alt="Leshu" width="160">
</p>

# Lichii Leshu 6

[English](README.md) · **Español**

**Leshu 6** es la **build 117** de [zortos293/Lichii](https://github.com/zortos293/Lichii) (un emulador de Switch 2) con dos añadidos: **instantáneas de las lecturas DMA de macros** y **espaciado de la generación de fotogramas**. Todo el código restante, los ajustes y el perfil PGO son los que publica zortos293.

## Instantáneas de las lecturas DMA (nuevo en Leshu 6)

Ocarina of Time lee un dato de oclusión por cada objeto unas 40.000 veces por segundo, y cada lectura hacía que los dos hilos de GPU se esperaran. Leshu 6 se salta esa espera mientras nada enviado después haya podido cambiar esos datos. La idea es el arreglo de EvilOOT, tal como lo incorporó Frizti a Lichii Frizti; Leshu lo adapta a la build 117.

El mismo programa con el arreglo apagado y encendido, portátil 720p, i7-11700F + RTX 3060:

| | Apagado | **Encendido** |
|---|---|---|
| Aldea Kokiri, quieto | 29,6 | **32,3 (+9%)** |
| Campo de Hyrule, quieto | 35,6 | **38,2 (+7%)** |
| Aldea Kokiri, caminando (dos pruebas) | 28,6 / 28,7 | **40,7 / 32,6** |

Caminando, los FPS varían mucho según la cámara: toma esas dos cifras como aproximadas. En modo verificación se comparó cada lectura saltada con la lectura segura: 0 diferencias en 11,5 millones de lecturas. La build 117 no tiene detector de destellos, así que los destellos blancos solo se revisaron a ojo, en una sesión de juego y en un solo PC. `EDEN_NX2_DMA_SNAPSHOT=0` en `nx2_switches.txt` lo desactiva.

## Espaciado de la generación de fotogramas

Con la generación activa, cada fotograma generado se presentaba justo antes del real, así que llegaban a pares. Leshu 5 los reparte por igual.

Build 117, límite de 30 FPS, FSR3 ×2, aldea Kokiri, Link quieto, dos pruebas de cada:

| | Sin espaciado | **Con espaciado** |
|---|---|---|
| Intervalos de envío | mitad por debajo de 4 ms, mitad por encima de 30 ms | **85-91% entre 12 y 20 ms** |
| Intervalo más largo | 42-46 ms | **24-26 ms** |
| FPS del juego | 27,6 / 28,7 | 29,4 / 29,8 |

Son los momentos en que el emulador envía cada fotograma a la pantalla, en un solo PC (i7-11700F + RTX 3060) y una sola escena. `EDEN_NX2_FG_PACE=0` lo desactiva. Sin generación de fotogramas, el código no hace nada.

Para usarlo: Emulación → Configurar → Gráficos → Enable Frame Generation (FSR3, ×2). Un límite como `FPS Limit` = 30 en la misma pestaña lo mantiene estable.

## Instalación (Windows)

1. Instala el [Microsoft Visual C++ Redistributable (x64)](https://aka.ms/vs/17/release/vc_redist.x64.exe) si no lo tienes.
2. Descarga `Leshu-6-Windows-x64.zip` de [Releases](https://github.com/leshupro/Leshu/releases) y extrae la carpeta completa.
3. Pon tus propios `prod.keys` y `title.keys` en `user/keys/` e instala el firmware sacado de tu propia consola (Herramientas → Instalar firmware).
4. Abre **lichii.exe**. Al arrancar por primera vez crea los ajustes que recomienda zortos293.

Empieza con una carpeta `user` nueva. Una configuración antigua puede guardar valores que esta versión interpreta de otra forma (precisión de GPU más lenta, shaders síncronos). La caché de shaders empieza vacía, así que habrá tirones la primera vez que aparezca cada cosa. Leshu **no incluye claves, firmware ni juegos**: sácalos de tu propia consola.

## Lo que se midió y no ayudó

Un perfil PGO grabado jugando (caminando, seis situaciones) no superó al perfil oficial, así que no va incluido (portátil 720p, oficial contra perfil grabado jugando: aldea quieto 30,3 contra 29,9; Hyrule quieto 35,8 contra 36,8; aldea caminando 43,75 y 43,05 contra 44,2 y 39,1; Hyrule caminando 39,1 contra 40,3).

## Compilar

Visual Studio 2022/2026 con "Desarrollo para el escritorio con C++", los componentes de herramientas Clang de C++ y de CMake, y el Vulkan SDK. Los scripts tienen rutas absolutas; ajústalas a las tuyas.

```bat
leshu\scripts\configure_z.bat build-z117 D:/lichii/zsrc/lichii-windows.profdata
leshu\scripts\build_dir.bat build-z117
```

Leshu 5 está en la [rama `leshu5`](https://github.com/leshupro/Leshu/tree/leshu5). Leshu 1-4 (basadas en Lichii Frizti v3) están en la [rama `leshu`](https://github.com/leshupro/Leshu/tree/leshu).

## Créditos

- **Lichii**, de zortos293 y colaboradores: todo lo que hay en Leshu 6 salvo los dos añadidos.
- **EvilOOT** (el arreglo de las lecturas DMA) y **Frizti** (su incorporación a Lichii), y Lichii Frizti.
- **Eglantine**, **Eden**, **Sudachi** y antes el proyecto **yuzu**.
- **Dynamic FPS by Dark**, incluido en Lichii.
- Adaptación a la build 117, espaciado y mediciones: leshupro, con Claude (Anthropic).

El README original de Lichii está en [README.lichii.md](README.lichii.md).

## Licencia

GPL-3.0 o posterior, como Lichii. Sin relación con Nintendo.
