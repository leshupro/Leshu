<p align="center">
  <img src="leshu/leshu.png" alt="Leshu" width="160">
</p>

# Lichii Leshu 5

[English](README.md) · **Español**

**Leshu 5** es la **build 117** de [zortos293/Lichii](https://github.com/zortos293/Lichii) (un emulador de Switch 2) con un único añadido: **espaciado de la generación de fotogramas**. Todo el código restante, los ajustes y el perfil PGO son los que publica zortos293.

> Jugando normal, sin generación de fotogramas, Leshu 5 **no es más rápida** que la build 117 oficial. Si no usas la generación de fotogramas, usa la oficial.

## Qué añade

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
2. Descarga `Leshu-5-Windows-x64.zip` de [Releases](https://github.com/leshupro/Leshu/releases) y extrae la carpeta completa.
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

Leshu 1-4 (basadas en Lichii Frizti v3) están en la [rama `leshu`](https://github.com/leshupro/Leshu/tree/leshu).

## Créditos

- **Lichii**, de zortos293 y colaboradores: todo lo que hay en Leshu 5 salvo el espaciado.
- **Lichii Frizti**, de Frizti, **Eglantine**, **Eden**, **Sudachi** y antes el proyecto **yuzu**.
- **Dynamic FPS by Dark**, incluido en Lichii.
- Espaciado y mediciones: leshupro, con Claude (Anthropic).

El README original de Lichii está en [README.lichii.md](README.lichii.md).

## Licencia

GPL-3.0 o posterior, como Lichii. Sin relación con Nintendo.
